// Swift in Practice — Edition #43: When Is an Offline Map Ready on Apple Watch?
// Section: Download, transfer, and installation are three facts
// https://swiftinpractice.com/editions/43-watchos-offline-map-packs/#download-transfer-and-installation-are-three-facts

import CryptoKit
import Foundation

struct MapPackManifest: Sendable {
    let regionID: String
    let revision: UInt64
    let byteCount: Int
    let sha256: [UInt8]
}

enum MapPackError: Error {
    case badManifest
    case wrongSize
    case wrongDigest
}

func verifyMapPack(_ url: URL, against manifest: MapPackManifest) throws {
    guard manifest.byteCount > 0, manifest.sha256.count == 32 else {
        throw MapPackError.badManifest
    }
    let handle = try FileHandle(forReadingFrom: url)
    defer { try? handle.close() }

    var bytesRead = 0
    var hash = SHA256()
    while true {
        try Task.checkCancellation()
        guard let chunk = try handle.read(upToCount: 64 * 1024),
              !chunk.isEmpty else { break }
        guard chunk.count <= manifest.byteCount - bytesRead else {
            throw MapPackError.wrongSize
        }
        bytesRead += chunk.count
        hash.update(data: chunk)
    }
    guard bytesRead == manifest.byteCount else { throw MapPackError.wrongSize }
    guard Array(hash.finalize()) == manifest.sha256 else { throw MapPackError.wrongDigest }
}
