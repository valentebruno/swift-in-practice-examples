// Swift in Practice — Edition #36: A Coordinate Is an Observation, Not the Truth
// Section: Keep the evidence with the value
// https://swiftinpractice.com/editions/36-coordinates-evidence-and-location-quality/#keep-the-evidence-with-the-value

import Foundation

struct LocationObservation: Equatable, Sendable {
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
