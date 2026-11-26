// Swift in Practice — Edition #21: Your Protocol Is Not an Architecture
// Section: Where customization actually happens
// https://swiftinpractice.com/editions/21-your-protocol-is-not-an-architecture/#where-customization-actually-happens

protocol Playback {
    func play()
}

extension Playback {
    func stop() -> String { "default extension" }
}

struct VideoPlayback: Playback {
    func play() {}
    func stop() -> String { "concrete type" }
}

func demonstrateDispatch() -> (concrete: String, existential: String) {
    let concrete = VideoPlayback()
    let abstract: any Playback = concrete
    return (concrete.stop(), abstract.stop())
    // ("concrete type", "default extension")
}
