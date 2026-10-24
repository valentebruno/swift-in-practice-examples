# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: HEVC Variant (for modern audiences) - CORRECTED
# https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#hevc-variant-for-modern-audiences-corrected

# Legacy H.264 with MPEG-TS (for very old devices)
ffmpeg -i input.mp4 \
  -c:v libx264 -preset medium \
  -b:v 1000k -maxrate 1100k -bufsize 2200k \
  -c:a aac -b:a 96k \
  -f hls \
  -hls_time 6 \
  -hls_segment_filename "legacy_%03d.ts" \
  legacy.m3u8
