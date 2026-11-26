// Swift in Practice — Edition #40: From Maps to Spatial Experiences
// Section: One owner for the effects
// https://swiftinpractice.com/editions/40-location-intelligence-4-spatial-experiences/#one-owner-for-the-effects

#if os(visionOS)
import SwiftUI

extension OpenOutcome {
    init(_ result: OpenImmersiveSpaceAction.Result) {
        switch result {
        case .opened: self = .opened
        case .userCancelled: self = .cancelled
        case .error: self = .failed
        @unknown default: self = .failed
        }
    }
}

struct ExploreButton: View {
    let placeID: UUID
    let coordinator: SpatialCoordinator

    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        Button("Explore in 3D") {
            Task {
                await coordinator.show(
                    placeID: placeID,
                    open: { id in
                        OpenOutcome(await openImmersiveSpace(id: "place", value: id))
                    },
                    dismiss: { await dismissImmersiveSpace() }
                )
            }
        }
        .disabled(coordinator.presentation == .unavailable)
    }
}
#endif
