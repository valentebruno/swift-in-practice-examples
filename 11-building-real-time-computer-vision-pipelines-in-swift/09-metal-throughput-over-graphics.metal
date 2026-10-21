// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: 6️⃣ Metal: Throughput Over Graphics
// https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#6-metal-throughput-over-graphics

kernel void processFrame(
    texture2d<float, access::read> yTexture [[texture(0)]],
    texture2d<float, access::read> uvTexture [[texture(1)]],
    texture2d<float, access::write> output [[texture(2)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= output.get_width() || gid.y >= output.get_height()) {
        return;
    }

    float y = yTexture.read(gid).r;
    uint2 uvCoord = uint2(gid.x / 2, gid.y / 2);
    float2 uv = uvTexture.read(uvCoord).rg;

    // YUV to RGB conversion (BT.709)
    float r = y + 1.5748 * (uv.y - 0.5);
    float g = y - 0.1873 * (uv.x - 0.5) - 0.4681 * (uv.y - 0.5);
    float b = y + 1.8556 * (uv.x - 0.5);

    output.write(float4(r, g, b, 1.0), gid);
}
