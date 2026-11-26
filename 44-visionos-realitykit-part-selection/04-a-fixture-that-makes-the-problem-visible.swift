// Swift in Practice — Edition #44: Selecting 3D Parts Reliably on visionOS
// Section: A fixture that makes the problem visible
// https://swiftinpractice.com/editions/44-visionos-realitykit-part-selection/#a-fixture-that-makes-the-problem-visible

import Foundation
import RealityKit

struct AssemblyManifest: Decodable, Sendable {
    struct Entry: Decodable, Sendable {
        let part: AssemblyPart
        let root: String            // a path the asset pipeline promises to keep
    }
    let revision: Int
    let parts: [Entry]
}

extension Entity {
    func descendant(atPath path: String) -> Entity? {
        let components = path.split(separator: "/")
        guard !components.isEmpty else { return nil }

        var current = self
        for name in components {
            guard let child = current.children.first(where: { $0.name == name }) else {
                return nil
            }
            current = child
        }
        return current
    }
}

struct LoadedAssembly {
    let root: Entity
    let missing: [AssemblyPart]
}

@MainActor
func loadAssembly(from url: URL, manifest: AssemblyManifest) async throws -> LoadedAssembly {
    let root = try await Entity(contentsOf: url)
    var missing: [AssemblyPart] = []
    for entry in manifest.parts {
        guard let partRoot = root.descendant(atPath: entry.root) else {
            missing.append(entry.part)
            continue
        }
        partRoot.components.set(PartIdentity(part: entry.part))
        partRoot.components.set(InputTargetComponent())
        partRoot.generateCollisionShapes(recursive: true)
    }
    return LoadedAssembly(root: root, missing: missing)
}
