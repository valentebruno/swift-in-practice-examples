# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: Creating HLS Streams with FFmpeg
# https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#creating-hls-streams-with-ffmpeg

ffmpeg -i input.mp4 \
  -c:v libx264 -preset medium -b:v 3000k -maxrate 3300k -bufsize 6600k \
  -c:a aac -b:a 128k \
  -f hls -hls_time 6 -hls_list_size 0 \
  -hls_segment_filename "stream_%03d.ts" \
  output.m3u8
