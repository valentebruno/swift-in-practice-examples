// Swift in Practice — Edition #36: A Coordinate Is an Observation, Not the Truth
// Section: Keep the evidence with the value
// https://swiftinpractice.com/editions/36-coordinates-evidence-and-location-quality/#keep-the-evidence-with-the-value

import CoreLocation

extension LocationObservation {
    init?(_ location: CLLocation, receivedAt: Date) {
        guard location.horizontalAccuracy >= 0,
              CLLocationCoordinate2DIsValid(location.coordinate) else {
            return nil
        }
        self.init(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            horizontalAccuracyMeters: location.horizontalAccuracy,
            observedAt: location.timestamp,
            receivedAt: receivedAt,
            source: .coreLocation
        )
    }
}
