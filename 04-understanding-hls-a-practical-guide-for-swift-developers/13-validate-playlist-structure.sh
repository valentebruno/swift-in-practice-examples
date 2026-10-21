# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: Validate Playlist Structure
# https://swiftinpractice.pages.dev/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#validate-playlist-structure

# Download and inspect playlists manually
curl https://your-cdn.com/master.m3u8

# Check for common issues:
# - Missing #EXTM3U header
# - Incorrect #EXT-X-VERSION
# - Mismatched segment durations vs #EXT-X-TARGETDURATION
