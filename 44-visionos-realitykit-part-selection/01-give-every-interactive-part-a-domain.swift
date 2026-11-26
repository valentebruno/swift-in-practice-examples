// Swift in Practice — Edition #44: Selecting 3D Parts Reliably on visionOS
// Section: Give every interactive part a domain identity
// https://swiftinpractice.com/editions/44-visionos-realitykit-part-selection/#give-every-interactive-part-a-domain-identity

import RealityKit
import SwiftUI

enum AssemblyPart: String, CaseIterable, Identifiable, Sendable {
    case housing = "Housing"
    case bracket = "Bracket"

    var id: Self { self }
}

struct PartIdentity: Component {
    let part: AssemblyPart
}

@main
struct AssemblyExampleApp: App {
    init() { PartIdentity.registerComponent() }

    var body: some SwiftUI.Scene {
        WindowGroup { AssemblySelectionView() }
    }
}

struct AssemblySelectionView: View {
    @State private var selection: AssemblyPart?

    var body: some View {
        VStack {
            RealityView { content in
                for (index, part) in AssemblyPart.allCases.enumerated() {
                    let size: Float = 0.08
                    let entity = ModelEntity(
                        mesh: .generateBox(size: size),
                        materials: [SimpleMaterial(color: .cyan, isMetallic: false)]
                    )
                    entity.position.x = Float(index) * 0.14 - 0.07
                    entity.components.set(PartIdentity(part: part))
                    entity.components.set(InputTargetComponent())
                    entity.components.set(HoverEffectComponent())
                    entity.components.set(CollisionComponent(shapes: [
                        .generateBox(size: SIMD3<Float>(repeating: size))
                    ]))
                    content.add(entity)
                }
            }
            .gesture(
                TapGesture().targetedToAnyEntity()
                    .onEnded { value in
                        if let part = value.entity.assemblyPart {
                            selection = part
                        }
                    }
            )

            HStack {
                ForEach(AssemblyPart.allCases) { part in
                    Button(part.rawValue) { selection = part }
                        .accessibilityAddTraits(selection == part ? .isSelected : [])
                }
            }

            if let selection {
                Text("Selected: \(selection.rawValue)")
            }
        }
    }
}
