// Swift in Practice — Edition #36: A Coordinate Is an Observation, Not the Truth
// Section: Distance between two estimates is an estimate
// https://swiftinpractice.com/editions/36-coordinates-evidence-and-location-quality/#distance-between-two-estimates-is-an-estimate

func longitudeDelta(from start: Double, to end: Double) -> Double {
    var delta = (end - start).truncatingRemainder(dividingBy: 360)
    if delta > 180 { delta -= 360 }
    if delta <= -180 { delta += 360 }
    return delta
}

func distanceMeters(
    from a: LocationObservation,
    to b: LocationObservation
) -> Double {
    let earthRadius = 6_371_008.8
    let lat1 = a.latitude * .pi / 180
    let lat2 = b.latitude * .pi / 180
    let dLat = lat2 - lat1
    let dLon = longitudeDelta(from: a.longitude, to: b.longitude) * .pi / 180

    let h = sin(dLat / 2) * sin(dLat / 2)
        + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2)
    return 2 * earthRadius * asin(min(1, h.squareRoot()))
}

func impliedSpeed(
    from earlier: LocationObservation,
    to later: LocationObservation
) -> Double? {
    let interval = later.observedAt.timeIntervalSince(earlier.observedAt)
    guard interval > 0 else { return nil }

    let distance = distanceMeters(from: earlier, to: later)
    let uncertainty = earlier.horizontalAccuracyMeters
        + later.horizontalAccuracyMeters
    guard distance > uncertainty else { return nil }

    return distance / interval
}
