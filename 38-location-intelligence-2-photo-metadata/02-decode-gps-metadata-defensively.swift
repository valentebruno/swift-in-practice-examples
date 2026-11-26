// Swift in Practice — Edition #38: Your Photos May Already Know Where They Were Taken
// Section: Decode GPS metadata defensively
// https://swiftinpractice.com/editions/38-location-intelligence-2-photo-metadata/#decode-gps-metadata-defensively

import ImageIO

enum GPSReading: Equatable, Sendable {
    case absent
    case malformed
    case coordinate(latitude: Double, longitude: Double)
}

func gpsReading(from properties: [CFString: Any]) -> GPSReading {
    guard let rawGPS = properties[kCGImagePropertyGPSDictionary] else { return .absent }
    guard let gps = rawGPS as? [CFString: Any] else { return .malformed }
    guard let latitude = gps[kCGImagePropertyGPSLatitude] as? Double,
          let longitude = gps[kCGImagePropertyGPSLongitude] as? Double,
          let latitudeRef = gps[kCGImagePropertyGPSLatitudeRef] as? String,
          let longitudeRef = gps[kCGImagePropertyGPSLongitudeRef] as? String,
          latitude.isFinite, longitude.isFinite,
          (0...90).contains(latitude),
          (0...180).contains(longitude) else {
        return .malformed
    }

    let latitudeSign: Double
    switch latitudeRef {
    case "N": latitudeSign = 1
    case "S": latitudeSign = -1
    default: return .malformed
    }

    let longitudeSign: Double
    switch longitudeRef {
    case "E": longitudeSign = 1
    case "W": longitudeSign = -1
    default: return .malformed
    }

    return .coordinate(
        latitude: latitude * latitudeSign,
        longitude: longitude * longitudeSign
    )
}

func imageProperties(at url: URL) -> [CFString: Any]? {
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
        return nil
    }
    return CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any]
}
