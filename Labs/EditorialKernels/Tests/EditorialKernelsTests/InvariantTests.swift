import Foundation
import Testing
@testable import EditorialKernels

@Test func staleOrConflictingSnapshotsCannotReplaceAcceptedEvidence() async {
    let account = UUID(), flight = UUID(), epoch = UUID()
    let store = FlightStore(accountID: account, flightID: flight, epoch: epoch)
    let latest = FlightSnapshot(accountID: account, flightID: flight, epoch: epoch,
                                revision: 9, status: .cancelled)
    let old = FlightSnapshot(accountID: account, flightID: flight, epoch: epoch,
                             revision: 3, status: .confirmed)
    let conflict = FlightSnapshot(accountID: account, flightID: flight, epoch: epoch,
                                  revision: 9, status: .delayed)
    #expect(await store.apply(latest) == .applied)
    #expect(await store.apply(old) == .stale)
    #expect(await store.apply(latest) == .duplicate)
    #expect(await store.apply(conflict) == .conflictingRevision)
    #expect(await store.snapshot() == latest)
}

@Test func aDifferentAccountCannotUpdateTheStore() async {
    let account = UUID(), flight = UUID(), epoch = UUID()
    let store = FlightStore(accountID: account, flightID: flight, epoch: epoch)
    let incoming = FlightSnapshot(accountID: UUID(), flightID: flight, epoch: epoch,
                                  revision: 99, status: .confirmed)
    #expect(await store.apply(incoming) == .wrongScope)
    #expect(await store.snapshot() == nil)
}

@Test func locationPolicyRejectsStaleFutureAndInvalidEvidence() {
    let now = Date(timeIntervalSince1970: 1_700_000_000)
    let policy = LocationPolicy(maximumAge: 10, maximumAccuracyMeters: 30,
                                allowedFutureSkew: 1)
    func observation(age: TimeInterval, accuracy: Double = 5) -> LocationObservation {
        LocationObservation(latitude: 40, longitude: -8,
                            horizontalAccuracyMeters: accuracy,
                            observedAt: now.addingTimeInterval(-age),
                            receivedAt: now, source: .coreLocation)
    }
    #expect(policy.accepts(observation(age: 5), now: now))
    #expect(!policy.accepts(observation(age: 11), now: now))
    #expect(!policy.accepts(observation(age: -2), now: now))
    #expect(!policy.accepts(observation(age: 0, accuracy: -1), now: now))
    #expect(!policy.accepts(observation(age: 0, accuracy: .nan), now: now))
}

@Test func obsoleteSpatialResultCannotReplaceTheCurrentRequest() {
    let current = UUID()
    let state = SpatialPresentation.opening(requestID: current, placeID: UUID())
    #expect(resolveOpen(state: state, requestID: UUID(), outcome: .opened) == state)
    #expect(resolveOpen(state: state, requestID: current, outcome: .cancelled) == .closed)
}

@Test func aLateUploadCompletionCannotResurrectACancelledAttempt() {
    let attempt = UUID()
    let uploading = UploadState.uploading(attempt: attempt)
    let cancelled = reduce(uploading, .cancel(attempt: attempt))
    #expect(cancelled == .cancelled(attempt: attempt))
    #expect(reduce(cancelled, .transferred(attempt: attempt, remoteID: "object")) == cancelled)
    #expect(reduce(cancelled, .verified(attempt: attempt, remoteID: "object")) == cancelled)
}

@Test func verificationMustMatchTheAttemptAndRemoteObject() {
    let attempt = UUID()
    let verifying = UploadState.verifying(attempt: attempt, remoteID: "expected")
    #expect(reduce(verifying, .verified(attempt: UUID(), remoteID: "expected")) == verifying)
    #expect(reduce(verifying, .verified(attempt: attempt, remoteID: "other")) == verifying)
    #expect(reduce(verifying, .verified(attempt: attempt, remoteID: "expected"))
            == .succeeded(remoteID: "expected"))
}

@Test func retryRejectsAnEarlierAttemptCompletion() {
    let old = UUID(), current = UUID()
    let failed = UploadState.failed(attempt: old, reason: "temporary")
    let retried = reduce(failed, .start(attempt: current))
    #expect(retried == .uploading(attempt: current))
    #expect(reduce(retried, .transferred(attempt: old, remoteID: "old")) == retried)
}
