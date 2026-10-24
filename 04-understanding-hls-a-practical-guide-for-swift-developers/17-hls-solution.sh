# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: HLS Solution:
# https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#hls-solution-2

# Live earnings call setup with quality assurance
ffmpeg -rtsp_transport tcp -i rtsp://studio.local/main \
  -filter_complex "
    [0:v]split=3[v1][v2][v3];
    [v1]scale=1920:1080[out1];
    [v2]scale=1280:720[out2];
    [v3]scale=854:480[out3]
  " \
  -map "[out1]" -c:v:0 libx264 -b:v:0 5000k -maxrate:v:0 5500k \
  -map "[out2]" -c:v:1 libx264 -b:v:1 2500k -maxrate:v:1 2750k \
  -map "[out3]" -c:v:2 libx264 -b:v:2 1000k -maxrate:v:2 1100k \
  -map 0:a -c:a aac -b:a 128k \
  -f hls \
  -hls_time 4 \
  -hls_list_size 10 \
  -hls_flags delete_segments \
  -master_pl_name master.m3u8 \
  -var_stream_map "v:0,a:0 v:1,a:0 v:2,a:0" \
  stream_%v.m3u8
