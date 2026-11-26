// Swift in Practice — Edition #37: MapKit Is Not Just a Map
// Section: A selected place is not its pin
// https://swiftinpractice.com/editions/37-location-intelligence-1-mapkit-domain/#a-selected-place-is-not-its-pin

import MapKit
import Observation
import SwiftUI

struct Place: Identifiable, Hashable, Sendable {
    enum Origin: Hashable, Sendable {
        case search(providerID: String?)
        case userWaypoint
    }

    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let origin: Origin

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Place {
    init(_ item: MKMapItem) {
        self.init(
            id: UUID(),
            name: item.name ?? "Unnamed place",
            latitude: item.location.coordinate.latitude,
            longitude: item.location.coordinate.longitude,
            origin: .search(providerID: item.identifier?.rawValue)
        )
    }
}

func refreshedMapItem(forProviderID providerID: String) async throws -> MKMapItem? {
    guard let identifier = MKMapItem.Identifier(rawValue: providerID) else {
        return nil
    }
    return try await MKMapItemRequest(mapItemIdentifier: identifier).mapItem
}
