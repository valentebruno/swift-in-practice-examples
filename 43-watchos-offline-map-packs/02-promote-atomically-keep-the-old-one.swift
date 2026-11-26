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
    readIdentity: (URL) throws -> InstalledPack
) throws -> InstalledPack {
    let allowed = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_")
    guard !manifest.regionID.isEmpty, manifest.regionID.allSatisfy(allowed.contains) else {
        throw MapPackError.badManifest
    }

    try verifyMapPack(staged, against: manifest)
    let incoming = try readIdentity(staged)   // open the pack with the actual decoder
    guard incoming == InstalledPack(regionID: manifest.regionID, revision: manifest.revision) else {
        throw MapPackError.wrongIdentity
    }

    let destination = packsDirectory.appending(component: "\(manifest.regionID).mappack")
    try Task.checkCancellation()
    if FileManager.default.fileExists(atPath: destination.path(percentEncoded: false)) {
        let installed = try readIdentity(destination)
        guard installed.regionID == incoming.regionID else { throw MapPackError.wrongIdentity }
        guard installed.revision < incoming.revision else { return installed }
        _ = try FileManager.default.replaceItemAt(destination, withItemAt: staged)
    } else {
        try FileManager.default.moveItem(at: staged, to: destination)
    }
    return incoming
}
