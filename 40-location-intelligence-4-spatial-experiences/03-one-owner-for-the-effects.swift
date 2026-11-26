// Swift in Practice — Edition #40: From Maps to Spatial Experiences
// Section: One owner for the effects
// https://swiftinpractice.com/editions/40-location-intelligence-4-spatial-experiences/#one-owner-for-the-effects

@MainActor
@Observable
final class SpatialCoordinator {
    private(set) var presentation: SpatialPresentation = .closed
    private(set) var isTransitioning = false
    private var desiredPlaceID: UUID?

    func show(
        placeID: UUID,
        open: (UUID) async -> OpenOutcome,
        dismiss: () async -> Void
    ) async {
        desiredPlaceID = placeID
        guard !isTransitioning else { return }
        isTransitioning = true
        defer { isTransitioning = false }

        while presentation.placeID != desiredPlaceID {
            if case let .open(sessionID, _) = presentation {
                presentation = .closing(sessionID: sessionID)
                await dismiss()
                presentation = .closed
                continue
            }
            guard let target = desiredPlaceID else { break }

            let requestID = UUID()
            presentation = .opening(requestID: requestID, placeID: target)
            let outcome = await open(target)
            presentation = resolveOpen(
                state: presentation, requestID: requestID, outcome: outcome
            )

            guard case .open = presentation else {
                desiredPlaceID = nil
                return
            }
        }
    }

    func close(dismiss: () async -> Void) async {
        desiredPlaceID = nil
        guard !isTransitioning, case let .open(sessionID, _) = presentation else {
            return
        }
        isTransitioning = true
        defer { isTransitioning = false }

        presentation = .closing(sessionID: sessionID)
        await dismiss()
        presentation = .closed
    }

    func spaceDidDisappear() {
        guard !isTransitioning else { return }
        desiredPlaceID = nil
        presentation = .closed
    }
}
