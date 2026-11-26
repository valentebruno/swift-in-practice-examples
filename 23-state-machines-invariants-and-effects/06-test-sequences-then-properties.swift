// Swift in Practice — Edition #23: Your App Has More States Than Your Model Admits
// Section: Test sequences, then properties
// https://swiftinpractice.com/editions/23-state-machines-invariants-and-effects/#test-sequences-then-properties

struct SeededGenerator: RandomNumberGenerator {
    var state: UInt64

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

func firstInvariantViolation(seed: UInt64, steps: Int) -> [UploadEvent]? {
    var generator = SeededGenerator(state: seed)
    let attempts = [UUID(), UUID(), UUID()]
    let remoteIDs = ["x", "y"]

    var state = UploadState.idle
    var history: [UploadEvent] = []

    for _ in 0..<steps {
        let attempt = attempts.randomElement(using: &generator)!
        let remoteID = remoteIDs.randomElement(using: &generator)!
        let event: UploadEvent = switch Int.random(in: 0..<5, using: &generator) {
        case 0: .start(attempt: attempt)
        case 1: .transferred(attempt: attempt, remoteID: remoteID)
        case 2: .verified(attempt: attempt, remoteID: remoteID)
        case 3: .failed(attempt: attempt, reason: "generated")
        default: .cancel(attempt: attempt)
        }

        let previous = state
        state = reduce(state, event)
        history.append(event)

        if case .succeeded(let succeededID) = state, previous != state {
            guard case let .verifying(current, expectedID) = previous,
                  case let .verified(eventAttempt, eventID) = event,
                  current == eventAttempt,
                  expectedID == eventID,
                  eventID == succeededID else {
                return history
            }
        }
    }
    return nil
}
