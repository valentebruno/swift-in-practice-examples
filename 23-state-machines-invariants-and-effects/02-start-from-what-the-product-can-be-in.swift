// Swift in Practice — Edition #23: Your App Has More States Than Your Model Admits
// Section: Start from what the product can be in
// https://swiftinpractice.com/editions/23-state-machines-invariants-and-effects/#start-from-what-the-product-can-be-in

import Foundation
import Observation

enum UploadState: Equatable, Sendable {
    case idle
    case uploading(attempt: UUID)
    case verifying(attempt: UUID, remoteID: String)
    case succeeded(remoteID: String)
    case failed(attempt: UUID, reason: String)
    case cancelled(attempt: UUID)

    var activeAttempt: UUID? {
        switch self {
        case .uploading(let attempt), .verifying(let attempt, _): attempt
        case .idle, .succeeded, .failed, .cancelled: nil
        }
    }
}

enum UploadEvent: Equatable, Sendable {
    case start(attempt: UUID)
    case transferred(attempt: UUID, remoteID: String)
    case verified(attempt: UUID, remoteID: String)
    case failed(attempt: UUID, reason: String)
    case cancel(attempt: UUID)
}
