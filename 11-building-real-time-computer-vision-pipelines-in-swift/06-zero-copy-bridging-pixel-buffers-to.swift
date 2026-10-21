// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: 5️⃣ Zero-Copy: Bridging Pixel Buffers to Metal
// https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#5-zero-copy-bridging-pixel-buffers-to-metal

// Per frame - creating textures from 420f format
// You need TWO textures: one for Y plane, one for UV plane
var yTexture: CVMetalTexture?
CVMetalTextureCacheCreateTextureFromImage(
    kCFAllocatorDefault,
    textureCache,
    pixelBuffer,
    nil,
    .r8Unorm,  // Y plane is single channel
    width,
    height,
    0,  // plane index 0
    &yTexture
)

var uvTexture: CVMetalTexture?
CVMetalTextureCacheCreateTextureFromImage(
    kCFAllocatorDefault,
    textureCache,
    pixelBuffer,
    nil,
    .rg8Unorm,  // UV plane is two channels
    width / 2,
    height / 2,
    1,  // plane index 1
    &uvTexture
)

guard let yTex = CVMetalTextureGetTexture(yTexture),
      let uvTex = CVMetalTextureGetTexture(uvTexture) else {
    return
}

// Your compute shader now has access to both planes
// If you need BGRA, do the YUV→RGB conversion in the shader
