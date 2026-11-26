// Swift in Practice — Edition #43: When Is an Offline Map Ready on Apple Watch?
// Section: Promote atomically, keep the old one until then
// https://swiftinpractice.com/editions/43-watchos-offline-map-packs/#promote-atomically-keep-the-old-one-until-then

struct InstalledPack: Sendable, Equatable {
    let regionID: String
    let revision: UInt64
}

func promote(
    staged: URL,
    manifest: MapPackManifest,
    packsDirectory: URL,
    opens: (URL) throws -> Void
) throws -> InstalledPack {
    try verifyMapPack(staged, against: manifest)
    try opens(staged)                       // the map engine reads it, or this throws

    let destination = packsDirectory
        .appending(path: "\(manifest.regionID).mappack")
    if FileManager.default.fileExists(atPath: destination.path(percentEncoded: false)) {
        _ = try FileManager.default.replaceItemAt(destination, withItemAt: staged)
    } else {
        try FileManager.default.moveItem(at: staged, to: destination)
    }
    return InstalledPack(regionID: manifest.regionID, revision: manifest.revision)
}
