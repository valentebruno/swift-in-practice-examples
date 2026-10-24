// Swift in Practice — Edition #7: HLS & Metal: Architectural Clarity for Video Streaming at Scale
// Section: Introduction
// https://swiftinpractice.com/editions/7-hls-and-metal-architectural-clarity-for-video/#introduction

#include <metal_stdlib>
using namespace metal;

vertex float4 vertexShader(uint vid [[vertex_id]]) {
    static const float2 coords[3] = {
        float2(-1.0, -1.0),
        float2( 3.0, -1.0),
        float2(-1.0,  3.0)
    };
    return float4(coords[vid], 0.0, 1.0);
}

fragment float4 colorGradingShader(float4 pos [[position]], texture2d<float> src [[texture(0)]]) {
    constexpr sampler s(mag_filter::linear, min_filter::linear, address::clamp_to_edge);
    float2 uv = pos.xy / float2(src.get_width(), src.get_height());
    float4 color = src.sample(s, uv);
    float3 adjusted = clamp(color.rgb * 1.1, 0.0, 1.0);
    return float4(adjusted, color.a);
}
