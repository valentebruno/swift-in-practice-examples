# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: 3. Bitrate accuracy
# https://swiftinpractice.pages.dev/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#3-bitrate-accuracy

# Check actual bitrate of encoded segments
ffprobe -v quiet -show_format segment-0.ts | grep bit_rate
