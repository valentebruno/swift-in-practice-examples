// Swift in Practice — Edition #36: A Coordinate Is an Observation, Not the Truth
// Section: Use hysteresis for decisions at a boundary
// https://swiftinpractice.com/editions/36-coordinates-evidence-and-location-quality/#use-hysteresis-for-decisions-at-a-boundary

struct ArrivalDetector: Sendable {
    enum State: Equatable, Sendable {
        case undetermined, arrived, away
    }

    let enterRadius: Double
    let exitRadius: Double
    let requiredSamples: Int

    private(set) var state: State = .undetermined
    private var candidate: State?
    private var streak = 0

    init(enterRadius: Double, exitRadius: Double, requiredSamples: Int) {
        precondition(exitRadius > enterRadius && requiredSamples > 0)
        self.enterRadius = enterRadius
        self.exitRadius = exitRadius
        self.requiredSamples = requiredSamples
    }

    mutating func ingest(distance: Double, accuracy: Double) -> State {
        let evidence: State?
        if distance + accuracy <= enterRadius {
            evidence = .arrived
        } else if distance - accuracy >= exitRadius {
            evidence = .away
        } else {
            evidence = nil
        }

        guard let evidence, evidence != state else {
            candidate = nil
            streak = 0
            return state
        }

        streak = (candidate == evidence) ? streak + 1 : 1
        candidate = evidence
        if streak >= requiredSamples {
            state = evidence
            candidate = nil
            streak = 0
        }
        return state
    }
}
