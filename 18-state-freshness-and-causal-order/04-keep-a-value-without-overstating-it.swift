// Swift in Practice — Edition #18: Your App Is Showing the Truth. Just Not the Current One.
// Section: Keep a value without overstating it
// https://swiftinpractice.com/editions/18-state-freshness-and-causal-order/#keep-a-value-without-overstating-it

enum Freshness: Equatable, Sendable {
    case current
    case aging(since: Duration)
    case expired
}

struct Observed<Value: Sendable>: Sendable {
    let value: Value
    let acceptedAt: ContinuousClock.Instant

    func freshness(
        now: ContinuousClock.Instant,
        currentFor: Duration,
        usableFor: Duration
    ) -> Freshness {
        let age = acceptedAt.duration(to: now)
        if age <= currentFor { return .current }
        if age <= usableFor { return .aging(since: age) }
        return .expired
    }
}
