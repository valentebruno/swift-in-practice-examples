// Swift in Practice — Edition #7: HLS & Metal: Architectural Clarity for Video Streaming at Scale
// Section: Introduction
// https://swiftinpractice.com/editions/7-hls-and-metal-architectural-clarity-for-video/#introduction

import MetalKit
import AVFoundation

final class VideoFilterProcessor {
    private let metalDevice: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let renderPipelineState: MTLRenderPipelineState
    private let textureCache: CVMetalTextureCache?
    private let gpuSlot = DispatchSemaphore(value: 1)

    // Hold input resources until completion. The callback is the only
    // CPU reader of output, after Metal finishes writing it.
    private struct FrameResources: @unchecked Sendable {
        let buffer: CVPixelBuffer
        let inputTexture: CVMetalTexture
        let outputTexture: any MTLTexture
    }

    init?() {
        guard let device = MTLCreateSystemDefaultDevice(),
              let queue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary(),
              let vertexFunction = library.makeFunction(name: "vertexShader"),
              let fragmentFunction = library.makeFunction(name: "colorGradingShader")
        else { return nil }

        metalDevice = device
        commandQueue = queue

        var cache: CVMetalTextureCache?
        CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &cache)
        textureCache = cache

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print("⚠️ Render pipeline creation failed: \(error)")
            return nil
        }
    }

    // Call from the capture or processing queue. The completion can run on Metal's queue.
    func processFrame(_ pixelBuffer: CVPixelBuffer, completion: @escaping @Sendable (CVPixelBuffer?) -> Void) {
        let slot = gpuSlot
        guard CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32BGRA,
              slot.wait(timeout: .now()) == .success else {
            completion(nil)
            return
        }

        var submitted = false
        defer { if !submitted { slot.signal() } }

        guard let wrappedTexture = textureFromPixelBuffer(pixelBuffer),
              let sourceTexture = CVMetalTextureGetTexture(wrappedTexture),
              let commandBuffer = commandQueue.makeCommandBuffer()
        else { completion(nil); return }

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)

        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm, width: width, height: height, mipmapped: false)
        descriptor.usage = [.renderTarget, .shaderRead]
        descriptor.storageMode = .shared

        guard let outputTexture = self.metalDevice.makeTexture(descriptor: descriptor) else { return completion(nil) }

        let renderPass = MTLRenderPassDescriptor()
        renderPass.colorAttachments[0].texture = outputTexture
        renderPass.colorAttachments[0].loadAction = .clear
        renderPass.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        renderPass.colorAttachments[0].storeAction = .store

        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPass) else { return completion(nil) }
        encoder.setRenderPipelineState(self.renderPipelineState)
        encoder.setFragmentTexture(sourceTexture, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder.endEncoding()

        let resources = FrameResources(
            buffer: pixelBuffer, inputTexture: wrappedTexture, outputTexture: outputTexture
        )
        commandBuffer.addCompletedHandler { result in
            let buffer = withExtendedLifetime(resources) {
                result.status == .completed
                    ? Self.pixelBufferFromTexture(resources.outputTexture)
                    : nil
            }
            slot.signal()
            completion(buffer)
        }
        submitted = true
        commandBuffer.commit()
    }

    private func textureFromPixelBuffer(_ pixelBuffer: CVPixelBuffer) -> CVMetalTexture? {
        guard let textureCache = textureCache else { return nil }
        var temp: CVMetalTexture?
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        CVMetalTextureCacheCreateTextureFromImage(nil, textureCache, pixelBuffer, nil, .bgra8Unorm, width, height, 0, &temp)
        return temp
    }

    private static func pixelBufferFromTexture(_ texture: MTLTexture) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        guard CVPixelBufferCreate(nil, texture.width, texture.height, kCVPixelFormatType_32BGRA, nil, &pixelBuffer) == kCVReturnSuccess,
              let buffer = pixelBuffer,
              CVPixelBufferLockBaseAddress(buffer, []) == kCVReturnSuccess else { return nil }
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
        guard let base = CVPixelBufferGetBaseAddress(buffer) else { return nil }
        texture.getBytes(base, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                         from: MTLRegionMake2D(0, 0, texture.width, texture.height), mipmapLevel: 0)
        return buffer
    }
}
