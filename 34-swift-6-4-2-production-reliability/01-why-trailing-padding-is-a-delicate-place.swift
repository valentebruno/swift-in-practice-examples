// Swift in Practice — Edition #34: Swift 6.4.2: What Compiler Fixes Reveal About Production Reliability
// Section: Why trailing padding is a delicate place
// https://swiftinpractice.com/editions/34-swift-6-4-2-production-reliability/#why-trailing-padding-is-a-delicate-place

struct Sample {
    var timestamp: Int64
    var channel: Int8
}

struct Tagged {
    var sample: Sample
    var isValid: Bool
}

func layoutFacts() -> [Int] {
    [
        MemoryLayout<Sample>.size,                  // 9
        MemoryLayout<Sample>.stride,                // 16
        MemoryLayout<Tagged>.size,                  // 10
        MemoryLayout<Tagged>.offset(of: \.isValid)! // 9
    ]
}
