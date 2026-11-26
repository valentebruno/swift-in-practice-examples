// Swift in Practice — Edition #38: Your Photos May Already Know Where They Were Taken
// Section: Export privacy is a property of the output bytes
// https://swiftinpractice.com/editions/38-location-intelligence-2-photo-metadata/#export-privacy-is-a-property-of-the-output-bytes

import UniformTypeIdentifiers

enum ExportError: Error, Equatable {
    case unreadableSource
    case encodingFailed
    case unverifiable
    case locationStillPresent
}

func containsLocationMetadata(at url: URL) -> Bool? {
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
            as? [CFString: Any] else {
        return nil
    }
    if properties[kCGImagePropertyGPSDictionary] != nil { return true }

    guard let metadata = CGImageSourceCopyMetadataAtIndex(source, 0, nil),
          let tags = CGImageMetadataCopyTags(metadata) as? [CGImageMetadataTag] else {
        return false
    }
    return tags.contains { tag in
        let name = (CGImageMetadataTagCopyName(tag) as String?) ?? ""
        return name.uppercased().hasPrefix("GPS")
    }
}

func exportDerivativeWithoutLocation(
    from sourceURL: URL,
    to destinationURL: URL,
    maxPixelSize: Int,
    quality: Double = 0.85
) throws(ExportError) {
    guard let source = CGImageSourceCreateWithURL(sourceURL as CFURL, nil) else {
        throw .unreadableSource
    }
    let decodeOptions: [CFString: Any] = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
    ]
    guard let pixels = CGImageSourceCreateThumbnailAtIndex(
        source, 0, decodeOptions as CFDictionary
    ) else {
        throw .unreadableSource
    }

    guard let destination = CGImageDestinationCreateWithURL(
        destinationURL as CFURL, UTType.jpeg.identifier as CFString, 1, nil
    ) else {
        throw .encodingFailed
    }
    let allowedProperties: [CFString: Any] = [
        kCGImageDestinationLossyCompressionQuality: quality
    ]
    CGImageDestinationAddImage(destination, pixels, allowedProperties as CFDictionary)
    guard CGImageDestinationFinalize(destination) else {
        throw .encodingFailed
    }

    switch containsLocationMetadata(at: destinationURL) {
    case .some(false):
        return
    case .some(true):
        try? FileManager.default.removeItem(at: destinationURL)
        throw .locationStillPresent
    case .none:
        try? FileManager.default.removeItem(at: destinationURL)
        throw .unverifiable
    }
}
