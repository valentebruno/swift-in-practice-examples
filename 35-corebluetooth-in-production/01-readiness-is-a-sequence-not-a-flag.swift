// Swift in Practice — Edition #35: Core Bluetooth in Production: From Connection to a Live Reading
// Section: Readiness is a sequence, not a flag
// https://swiftinpractice.com/editions/35-corebluetooth-in-production/#readiness-is-a-sequence-not-a-flag

import CoreBluetooth
import Foundation

struct Reading<Value: Sendable>: Sendable {
    let value: Value
    let receivedAt: ContinuousClock.Instant

    func isFresh(at now: ContinuousClock.Instant, maximumAge: Duration) -> Bool {
        let age = receivedAt.duration(to: now)
        return age >= .zero && age <= maximumAge
    }
}

enum LinkPhase: Sendable {
    case waitingForRadio
    case ready
    case connecting(attempt: UUID, peripheral: UUID)
    case preparing(peripheral: UUID)          // discovery and subscription
    case streaming(peripheral: UUID, last: Reading<Double>?)
    case unavailable(reason: String, last: Reading<Double>?)
}

enum LinkEvent: Sendable {
    case radioPoweredOn
    case radioReset
    case connectRequested(attempt: UUID, peripheral: UUID)
    case connected(peripheral: UUID)
    case connectionFailed(peripheral: UUID)
    case subscribed(peripheral: UUID)
    case sample(peripheral: UUID, Reading<Double>)
    case connectDeadlinePassed(attempt: UUID)
    case disconnected(peripheral: UUID)
}

func reduce(_ phase: LinkPhase, _ event: LinkEvent) -> LinkPhase {
    switch (phase, event) {
    case (_, .radioReset):
        return .waitingForRadio
    case (.waitingForRadio, .radioPoweredOn):
        return .ready
    case let (.ready, .connectRequested(attempt, id)),
         let (.unavailable, .connectRequested(attempt, id)):
        return .connecting(attempt: attempt, peripheral: id)
    case let (.connecting(_, expected), .connected(id)) where id == expected:
        return .preparing(peripheral: id)
    case let (.connecting(_, expected), .connectionFailed(id)) where id == expected,
         let (.connecting(_, expected), .disconnected(id)) where id == expected:
        return .unavailable(reason: "Could not connect to sensor", last: nil)
    case let (.preparing(expected), .subscribed(id)) where id == expected:
        return .streaming(peripheral: id, last: nil)
    case let (.streaming(expected, _), .sample(id, reading)) where id == expected:
        return .streaming(peripheral: id, last: reading)
    case let (.connecting(current, _), .connectDeadlinePassed(attempt)) where current == attempt:
        return .unavailable(reason: "Sensor not found nearby", last: nil)
    case let (.streaming(expected, last), .disconnected(id)) where id == expected:
        return .unavailable(reason: "Sensor disconnected", last: last)
    case let (.preparing(expected), .disconnected(id)) where id == expected:
        return .unavailable(reason: "Sensor disconnected during setup", last: nil)
    default:
        return phase
    }
}
