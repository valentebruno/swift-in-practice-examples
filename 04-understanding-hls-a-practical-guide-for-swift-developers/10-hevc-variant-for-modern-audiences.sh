# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: HEVC Variant (for modern audiences) - CORRECTED
# https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#hevc-variant-for-modern-audiences-corrected

ffmpeg -i input.mp4 \
  -c:v libx265 \
  -preset fast \
  -crf 23 \
  -tag:v hvc1 \
  -c:a aac -b:a 128k \
  -f hls \
  -hls_segment_type fmp4 \
  -hls_fmp4_init_filename "init.mp4" \
  -hls_segment_filename "segment_%03d.m4s" \
  -hls_time 6 \
  -hls_list_size 0 \
  output.m3u8
