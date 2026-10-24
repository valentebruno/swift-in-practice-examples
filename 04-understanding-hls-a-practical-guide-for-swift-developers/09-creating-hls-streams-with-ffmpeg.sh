# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: Creating HLS Streams with FFmpeg
# https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#creating-hls-streams-with-ffmpeg

# Live streaming from a camera or RTMP source
# Key: sliding window, lower latency, keyframe alignment

ffmpeg -rtsp_transport tcp -i rtsp://camera.local/stream \
  -c:v libx264 \
  -preset ultrafast \
  -b:v 2500k \
  -maxrate 2750k \
  -bufsize 5500k \
  -g 120 \
  -keyint_min 120 \
  -sc_threshold 0 \
  -c:a aac -b:a 128k \
  -f hls \
  -hls_time 10 \
  -hls_list_size 5 \
  -hls_flags delete_segments \
  live_stream.m3u8
