// Swift in Practice — Edition #38: Your Photos May Already Know Where They Were Taken
// Section: Keep provenance before choosing a coordinate
// https://swiftinpractice.com/editions/38-location-intelligence-2-photo-metadata/#keep-provenance-before-choosing-a-coordinate

import Foundation

struct PhotoLocationEvidence: Equatable, Sendable {
    enum Source: String, Sendable {
        case photoLibrary
        case embeddedMetadata
        case userAssigned
    }

    let latitude: Double
    let longitude: Double
    let source: Source
}

enum PhotoLocationResolution: Equatable, Sendable {
    case absent
    case available(PhotoLocationEvidence)
    case needsReview([PhotoLocationEvidence])
}

func resolveLocation(
    from evidence: [PhotoLocationEvidence],
    agreementMeters: Double = 250
) -> PhotoLocationResolution {
    if let assigned = evidence.last(where: { $0.source == .userAssigned }) {
        return .available(assigned)
    }
    guard let first = evidence.first else { return .absent }

    let allAgree = evidence.dropFirst().allSatisfy {
        approximateDistanceMeters(first, $0) <= agreementMeters
    }
    return allAgree ? .available(first) : .needsReview(evidence)
}

func approximateDistanceMeters(
    _ a: PhotoLocationEvidence, _ b: PhotoLocationEvidence
) -> Double {
    let metersPerDegree = 111_195.0
    let meanLatitude = (a.latitude + b.latitude) / 2 * .pi / 180
    var deltaLongitude = abs(a.longitude - b.longitude)
    if deltaLongitude > 180 { deltaLongitude = 360 - deltaLongitude }

    let north = (a.latitude - b.latitude) * metersPerDegree
    let east = deltaLongitude * metersPerDegree * cos(meanLatitude)
    return (north * north + east * east).squareRoot()
}
