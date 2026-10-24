# Edition #12 — Multi-Camera Capture on iOS: The Architecture No One Tells You About

> Hardware-synchronised AVCaptureMultiCamSession, shared Metal resources, capability checks, and thermal-aware degradation.

**Read the full edition on Swift in Practice:** https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/

Media & Camera · Build · 30 Jan 2026

## Snippets

| File | Language | Section |
|---|---|---|
| [`01-the-story-we-need-dual-camera-support.swift`](01-the-story-we-need-dual-camera-support.swift) | Swift | [The Story: “We Need Dual Camera Support”](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#the-story-we-need-dual-camera-support) |
| [`02-intuitive-wrong-approach.txt`](02-intuitive-wrong-approach.txt) | Text | [❌ Intuitive (Wrong) Approach](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#intuitive-wrong-approach) |
| [`03-production-architecture.txt`](03-production-architecture.txt) | Text | [✅ Production Architecture](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#production-architecture) |
| [`04-runtime-capability-check.swift`](04-runtime-capability-check.swift) | Swift | [Runtime Capability Check](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#runtime-capability-check) |
| [`05-validation-before-configuration.swift`](05-validation-before-configuration.swift) | Swift | [Validation Before Configuration](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#validation-before-configuration) |
| [`06-the-setup-gcd-based-for-performance.swift`](06-the-setup-gcd-based-for-performance.swift) | Swift | [The Setup (GCD-Based for Performance)](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#the-setup-gcd-based-for-performance) |
| [`07-frame-processing-the-sendable-safe.swift`](07-frame-processing-the-sendable-safe.swift) | Swift | [Frame Processing: The Sendable-Safe Pattern](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#frame-processing-the-sendable-safe-pattern) |
| [`08-production-pattern.swift`](08-production-pattern.swift) | Swift | [Production Pattern](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#production-pattern) |
| [`09-the-solution-trust-nothing.swift`](09-the-solution-trust-nothing.swift) | Swift | [The Solution: Trust Nothing](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#the-solution-trust-nothing) |
| [`10-sample-telemetry-implementation.swift`](10-sample-telemetry-implementation.swift) | Swift | [Sample Telemetry Implementation](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#sample-telemetry-implementation) |
| [`11-one-last-thing-the-buffer-pool-pattern.swift`](11-one-last-thing-the-buffer-pool-pattern.swift) | Swift | [One Last Thing: The Buffer Pool Pattern](https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#one-last-thing-the-buffer-pool-pattern) |

These are the snippets exactly as they appear in the edition. They are excerpts that rely on the
surrounding explanation, not a buildable project — the edition explains when and why to use each one.

---

[← All editions](../README.md) · [Swift in Practice](https://swiftinpractice.com/) · Code a Brighter Tomorrow.
