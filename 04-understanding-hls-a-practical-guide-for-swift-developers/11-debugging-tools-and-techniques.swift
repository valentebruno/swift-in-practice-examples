// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Debugging Tools and Techniques
// https://swiftinpractice.pages.dev/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#debugging-tools-and-techniques

// Monitor error log
player.currentItem?.errorLog()?.events.forEach { event in
    print("Error: \(event.errorComment ?? "Unknown")")
    print("Status: \(event.errorStatusCode)")
    print("Domain: \(event.errorDomain ?? "Unknown")")
}
