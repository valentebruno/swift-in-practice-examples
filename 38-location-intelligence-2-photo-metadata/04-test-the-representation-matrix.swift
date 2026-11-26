// Swift in Practice — Edition #38: Your Photos May Already Know Where They Were Taken
// Section: Test the representation matrix
// https://swiftinpractice.com/editions/38-location-intelligence-2-photo-metadata/#test-the-representation-matrix

import CoreGraphics

func writeFixtureJPEG(
    to url: URL,
    gps: [CFString: Any]?
) -> Bool {
    guard let context = CGContext(
        data: nil, width: 8, height: 8, bitsPerComponent: 8, bytesPerRow: 0,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    ), let image = context.makeImage(),
       let destination = CGImageDestinationCreateWithURL(
        url as CFURL, UTType.jpeg.identifier as CFString, 1, nil
       ) else {
        return false
    }
    var properties: [CFString: Any] = [:]
    if let gps { properties[kCGImagePropertyGPSDictionary] = gps }
    CGImageDestinationAddImage(destination, image, properties as CFDictionary)
    return CGImageDestinationFinalize(destination)
}
