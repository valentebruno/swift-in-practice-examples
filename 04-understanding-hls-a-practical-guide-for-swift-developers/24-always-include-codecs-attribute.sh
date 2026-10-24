# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: 1. Always include CODECS attribute
# https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#1-always-include-codecs-attribute

# Extract codec info
ffprobe -v quiet -show_streams -select_streams v:0 \
  -print_format json segment-0.ts | jq '.streams[0].codec_name'
