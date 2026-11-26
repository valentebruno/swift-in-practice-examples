// Swift in Practice — Edition #40: From Maps to Spatial Experiences
// Section: Geographic coordinates are not scene coordinates
// https://swiftinpractice.com/editions/40-location-intelligence-4-spatial-experiences/#geographic-coordinates-are-not-scene-coordinates

struct TabletopFrame: Sendable {
    let originLatitude: Double
    let originLongitude: Double
    let realMetersPerSceneMeter: Double

    func scenePosition(latitude: Double, longitude: Double) -> SIMD3<Float> {
        let metersPerDegree = 111_195.0
        var deltaLongitude = longitude - originLongitude
        if deltaLongitude > 180 { deltaLongitude -= 360 }
        if deltaLongitude < -180 { deltaLongitude += 360 }

        let north = (latitude - originLatitude) * metersPerDegree
        let east = deltaLongitude * metersPerDegree
            * cos(originLatitude * .pi / 180)

        return SIMD3(
            Float(east / realMetersPerSceneMeter),
            0,
            Float(-north / realMetersPerSceneMeter)
        )
    }
}
