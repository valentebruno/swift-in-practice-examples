// Swift in Practice — Edition #39: From Camera Frame to Map Pin
// Section: Four stages that should stay separate
// https://swiftinpractice.com/editions/39-location-intelligence-3-vision-evidence/#four-stages-that-should-stay-separate

import Foundation
import CoreGraphics

struct VisualClassification: Equatable, Sendable {
    let label: String
    let score: Float
    let modelVersion: String
    let frameID: UUID
}

struct CatalogPlace: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let labels: Set<String>
    let latitude: Double
    let longitude: Double
}

struct PlaceCandidate: Equatable, Sendable {
    let place: CatalogPlace
    let classification: VisualClassification
    let distanceMeters: Double?
}

enum PlaceResolution: Equatable, Sendable {
    case match(PlaceCandidate)
    case choices([PlaceCandidate])
    case unknown
}
