// Swift in Practice — Edition #34: Swift 6.4.2: What Compiler Fixes Reveal About Production Reliability
// Section: Unsafe code changes the burden of proof
// https://swiftinpractice.com/editions/34-swift-6-4-2-production-reliability/#unsafe-code-changes-the-burden-of-proof

func checksumPointerEscapes(_ bytes: [UInt8]) -> UnsafeRawBufferPointer {
    bytes.withUnsafeBytes { $0 }   // wrong: the pointer outlives the closure
}

func checksum(_ bytes: [UInt8]) -> UInt32 {
    bytes.withUnsafeBytes { buffer in
        buffer.reduce(UInt32(0)) { ($0 &* 31) &+ UInt32($1) }
    }
}
