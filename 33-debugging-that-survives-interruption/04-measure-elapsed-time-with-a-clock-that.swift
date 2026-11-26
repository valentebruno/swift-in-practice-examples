// Swift in Practice — Edition #33: Your Debugging Session Should Survive an Interruption
// Section: Measure elapsed time with a clock that cannot jump
// https://swiftinpractice.com/editions/33-debugging-that-survives-interruption/#measure-elapsed-time-with-a-clock-that-cannot-jump

func measureLoad(
    isolation: isolated (any Actor)? = #isolation,
    _ work: () async -> Void
) async -> Duration {
    let clock = ContinuousClock()
    let start = clock.now
    await work()
    return start.duration(to: clock.now)
}

func signpostedLoad(
    isolation: isolated (any Actor)? = #isolation,
    _ work: () async -> Void
) async {
    let signposter = OSSignposter(logger: Diagnostics.feed)
    let state = signposter.beginInterval("feed-load", id: signposter.makeSignpostID())
    await work()
    signposter.endInterval("feed-load", state)
}
