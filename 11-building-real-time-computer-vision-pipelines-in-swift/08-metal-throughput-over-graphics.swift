// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: 6️⃣ Metal: Throughput Over Graphics
// https://swiftinpractice.com/editions/11-building-real-time-computer-vision-pipelines-in-swift/#6-metal-throughput-over-graphics

guard let commandBuffer = commandQueue.makeCommandBuffer() else {
    return
}
guard let encoder = commandBuffer.makeComputeCommandEncoder() else {
    return
}

encoder.setComputePipelineState(pipelineState)
encoder.setTexture(yTexture, index: 0)
encoder.setTexture(uvTexture, index: 1)
encoder.setTexture(outputTexture, index: 2)

let threadgroupSize = MTLSize(width: 16, height: 16, depth: 1)
let threadgroupCount = MTLSize(
    width: (width + threadgroupSize.width - 1) / threadgroupSize.width,
    height: (height + threadgroupSize.height - 1) / threadgroupSize.height,
    depth: 1
)

encoder.dispatchThreadgroups(threadgroupCount, threadsPerThreadgroup: threadgroupSize)
encoder.endEncoding()
commandBuffer.commit()
