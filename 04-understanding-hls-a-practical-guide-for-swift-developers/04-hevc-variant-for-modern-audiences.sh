# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: HEVC Variant (for modern audiences) - CORRECTED
# https://swiftinpractice.pages.dev/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#hevc-variant-for-modern-audiences-corrected

# Validate the stream (requires Apple's HLS tools)
mediastreamvalidator https://your-cdn.com/master.m3u8

# Check for common issues:
# ✓ Correct CODECS attribute in master playlist
# ✓ fMP4 format detected (not TS)
# ✓ Initialization segments present
# ✓ Keyframe alignment across variants
# ✓ Bitrate compliance
