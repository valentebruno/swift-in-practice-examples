# Edition #11 — Building Real-Time Computer Vision Pipelines in Swift

> The production lessons behind stable 30–60 FPS camera pipelines: memory flow, zero-copy Metal mapping, thermal limits, and interruptions.

**Read the full edition on Swift in Practice:** https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/

Performance · Build · 29 Jan 2026

## Snippets

| File | Language | Section |
|---|---|---|
| [`01-the-mental-model-memory-flow-not-images.txt`](01-the-mental-model-memory-flow-not-images.txt) | Text | [1️⃣ The Mental Model: Memory Flow, Not Images](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#1-the-mental-model-memory-flow-not-images) |
| [`02-camera-output-where-performance-is.swift`](02-camera-output-where-performance-is.swift) | Swift | [2️⃣ Camera Output: Where Performance Is Decided](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#2-camera-output-where-performance-is-decided) |
| [`03-cmsamplebuffer-vs-cvpixelbuffer-know.swift`](03-cmsamplebuffer-vs-cvpixelbuffer-know.swift) | Swift | [3️⃣ CMSampleBuffer vs CVPixelBuffer: Know What You’re Touching](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#3-cmsamplebuffer-vs-cvpixelbuffer-know-what-you-re-touching) |
| [`04-cvpixelbuffer-memory-not-an-image.swift`](04-cvpixelbuffer-memory-not-an-image.swift) | Swift | [4️⃣ CVPixelBuffer: Memory, Not an Image](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#4-cvpixelbuffer-memory-not-an-image) |
| [`05-zero-copy-bridging-pixel-buffers-to.swift`](05-zero-copy-bridging-pixel-buffers-to.swift) | Swift | [5️⃣ Zero-Copy: Bridging Pixel Buffers to Metal](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#5-zero-copy-bridging-pixel-buffers-to-metal) |
| [`06-zero-copy-bridging-pixel-buffers-to.swift`](06-zero-copy-bridging-pixel-buffers-to.swift) | Swift | [5️⃣ Zero-Copy: Bridging Pixel Buffers to Metal](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#5-zero-copy-bridging-pixel-buffers-to-metal) |
| [`07-zero-copy-bridging-pixel-buffers-to.swift`](07-zero-copy-bridging-pixel-buffers-to.swift) | Swift | [5️⃣ Zero-Copy: Bridging Pixel Buffers to Metal](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#5-zero-copy-bridging-pixel-buffers-to-metal) |
| [`08-metal-throughput-over-graphics.swift`](08-metal-throughput-over-graphics.swift) | Swift | [6️⃣ Metal: Throughput Over Graphics](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#6-metal-throughput-over-graphics) |
| [`09-metal-throughput-over-graphics.metal`](09-metal-throughput-over-graphics.metal) | Metal | [6️⃣ Metal: Throughput Over Graphics](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#6-metal-throughput-over-graphics) |
| [`10-here-s-the-setup-that-works-reliably.swift`](10-here-s-the-setup-that-works-reliably.swift) | Swift | [Here’s the setup that works reliably:](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#here-s-the-setup-that-works-reliably) |
| [`11-here-s-the-setup-that-works-reliably.swift`](11-here-s-the-setup-that-works-reliably.swift) | Swift | [Here’s the setup that works reliably:](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#here-s-the-setup-that-works-reliably) |
| [`12-production-failure-modes.swift`](12-production-failure-modes.swift) | Swift | [8️⃣ Production Failure Modes](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#8-production-failure-modes) |
| [`13-phone-calls-control-center-picture-in.swift`](13-phone-calls-control-center-picture-in.swift) | Swift | [Phone calls. Control Center. Picture-in-Picture. FaceTime. Notification Center. Screen recording.](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#phone-calls-control-center-picture-in-picture-facetime-notif) |
| [`14-phone-calls-control-center-picture-in.swift`](14-phone-calls-control-center-picture-in.swift) | Swift | [Phone calls. Control Center. Picture-in-Picture. FaceTime. Notification Center. Screen recording.](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#phone-calls-control-center-picture-in-picture-facetime-notif) |
| [`15-memory-leaks-via-retain-cycles.swift`](15-memory-leaks-via-retain-cycles.swift) | Swift | [Memory Leaks via Retain Cycles](https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#memory-leaks-via-retain-cycles) |

These are the snippets exactly as they appear in the edition. They are excerpts that rely on the
surrounding explanation, not a buildable project — the edition explains when and why to use each one.

---

[← All editions](../README.md) · [Swift in Practice](https://swiftinpractice.pages.dev/) · Code a Brighter Tomorrow.
