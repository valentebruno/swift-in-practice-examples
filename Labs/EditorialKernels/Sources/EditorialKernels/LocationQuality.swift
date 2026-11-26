import Foundation

struct LocationObservation: Sendable {
    let latitude: Double
    let longitude: Double
    let horizontalAccuracyMeters: Double
    let observedAt: Date
    let receivedAt: Date
    let source: Source

    enum Source: String, Sendable {
        case coreLocation
        case importedTrack
        case userSelected
    }
}

struct LocationPolicy: Sendable {
    let maximumAge: TimeInterval
    let maximumAccuracyMeters: Double
    let allowedFutureSkew: TimeInterval

    func accepts(
        _ observation: LocationObservation,
        now: Date
    ) -> Bool {
        guard maximumAge.isFinite, maximumAge >= 0,
              maximumAccuracyMeters.isFinite,
              maximumAccuracyMeters >= 0,
              allowedFutureSkew.isFinite,
              allowedFutureSkew >= 0 else {
            return false
        }

        guard observation.latitude.isFinite,
              observation.longitude.isFinite,
              observation.horizontalAccuracyMeters.isFinite,
              (-90...90).contains(observation.latitude),
              (-180...180).contains(observation.longitude),
              observation.horizontalAccuracyMeters >= 0,
              observation.horizontalAccuracyMeters
                <= maximumAccuracyMeters else {
            return false
        }

        let age = now.timeIntervalSince(observation.observedAt)
        return age.isFinite
            && age >= -allowedFutureSkew
            && age <= maximumAge
    }
}
