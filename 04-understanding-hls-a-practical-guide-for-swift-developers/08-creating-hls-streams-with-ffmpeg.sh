# Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
# Section: Creating HLS Streams with FFmpeg
# https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#creating-hls-streams-with-ffmpeg

#!/bin/bash
# Excerpt: the loop continues with one ffmpeg command per variant.

# Create multiple quality variants
INPUT="input.mp4"

# Validate input file exists
if [ ! -f "$INPUT" ]; then
    echo "Error: Input file not found: $INPUT"
    exit 1
fi

# Check FFmpeg exists
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg not found. Please install ffmpeg."
    exit 1
fi

# Quality presets: width:height:video_bitrate:audio_bitrate
# Note: bitrates are in kbps without 'k' suffix
QUALITIES=(
    "3840:2160:8000:192"  # 4K
    "1920:1080:3500:128"  # 1080p
    "1280:720:2000:96"    # 720p
    "854:480:1000:96"     # 480p
    "640:360:500:64"      # 360p
)

echo "Starting multi-bitrate encoding..."

for quality in "${QUALITIES[@]}"; do
    IFS=':' read -r width height bitrate audio <<< "$quality"

    # Create directory for this quality
    mkdir -p "stream_${height}p"

    echo "Encoding ${height}p variant..."
    # …
