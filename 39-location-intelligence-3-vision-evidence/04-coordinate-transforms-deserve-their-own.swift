// Swift in Practice — Edition #39: From Camera Frame to Map Pin
// Section: Coordinate transforms deserve their own tests
// https://swiftinpractice.com/editions/39-location-intelligence-3-vision-evidence/#coordinate-transforms-deserve-their-own-tests

func topLeftImageRect(
    normalizedBottomLeft rect: CGRect,
    imageSize: CGSize
) -> CGRect {
    CGRect(
        x: rect.minX * imageSize.width,
        y: (1 - rect.maxY) * imageSize.height,
        width: rect.width * imageSize.width,
        height: rect.height * imageSize.height
    )
}

func aspectFillViewRect(
    imageRect: CGRect,
    imageSize: CGSize,
    viewSize: CGSize
) -> CGRect {
    let scale = max(
        viewSize.width / imageSize.width,
        viewSize.height / imageSize.height
    )
    let offsetX = (viewSize.width - imageSize.width * scale) / 2
    let offsetY = (viewSize.height - imageSize.height * scale) / 2

    return CGRect(
        x: imageRect.minX * scale + offsetX,
        y: imageRect.minY * scale + offsetY,
        width: imageRect.width * scale,
        height: imageRect.height * scale
    )
}
