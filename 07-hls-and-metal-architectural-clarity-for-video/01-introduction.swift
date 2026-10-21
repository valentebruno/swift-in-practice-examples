// Swift in Practice — Edition #7: HLS & Metal: Architectural Clarity for Video Streaming at Scale
// Section: Introduction
// https://swiftinpractice.pages.dev/editions/7-hls-and-metal-architectural-clarity-for-video/#introduction

import MetalKit
import AVFoundation

final class VideoFilterProcessor: NSObject {
    private let metalDevice: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let renderPipelineState: MTLRenderPipelineState
    private let textureCache: CVMetalTextureCache?
    private let processingQueue = DispatchQueue(label: "com.swiftinpractice.metal")
    private var isProcessing = false

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
        super.init()
    }

    func processFrame(_ pixelBuffer: CVPixelBuffer, completion: @escaping (CVPixelBuffer?) -> Void) {
        guard !isProcessing else { completion(nil); return }

        processingQueue.async { [weak self] in
            guard let self = self else { return }
            self.isProcessing = true
            defer { self.isProcessing = false }

            guard let sourceTexture = self.textureFromPixelBuffer(pixelBuffer),
                  let commandBuffer = self.commandQueue.makeCommandBuffer()
            else { return completion(nil) }

            let width = CVPixelBufferGetWidth(pixelBuffer)
            let height = CVPixelBufferGetHeight(pixelBuffer)

            let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm, width: width, height: height, mipmapped: false)
            descriptor.usage = [.renderTarget, .shaderRead]

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

            commandBuffer.addCompletedHandler { _ in
                completion(self.pixelBufferFromTexture(outputTexture))
            }
            commandBuffer.commit()
        }
    }

    private func textureFromPixelBuffer(_ pixelBuffer: CVPixelBuffer) -> MTLTexture? {
        guard let textureCache = textureCache else { return nil }
        var temp: CVMetalTexture?
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        CVMetalTextureCacheCreateTextureFromImage(nil, textureCache, pixelBuffer, nil, .bgra8Unorm, width, height, 0, &temp)
        return temp.flatMap { CVMetalTextureGetTexture($0) }
    }

    private func pixelBufferFromTexture(_ texture: MTLTexture) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(nil, texture.width, texture.height, kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
        guard let buffer = pixelBuffer, let base = CVPixelBufferGetBaseAddress(buffer) else { return nil }

        CVPixelBufferLockBaseAddress(buffer, .writeOnly)
        texture.getBytes(base, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                         from: MTLRegionMake2D(0, 0, texture.width, texture.height), mipmapLevel: 0)
        CVPixelBufferUnlockBaseAddress(buffer, .writeOnly)
        return buffer
    }
}
