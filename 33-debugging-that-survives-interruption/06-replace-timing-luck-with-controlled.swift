// Swift in Practice — Edition #33: Your Debugging Session Should Survive an Interruption
// Section: Replace timing luck with controlled ordering
// https://swiftinpractice.com/editions/33-debugging-that-survives-interruption/#replace-timing-luck-with-controlled-ordering

@MainActor
final class WorkspaceScreen {
    private(set) var visibleArticles: [String] = []
    private var generation = 0
    private let service: ControlledService<String, [String]>

    init(service: ControlledService<String, [String]>) {
        self.service = service
    }

    func select(workspace: String) async {
        generation += 1
        let token = generation
        guard let articles = try? await service.request(workspace) else { return }
        guard token == generation else { return }
        visibleArticles = articles
    }
}

@MainActor
func lateResponseDoesNotReplaceCurrentSelection() async -> Bool {
    let service = ControlledService<String, [String]>()
    let screen = WorkspaceScreen(service: service)

    let selectA = Task { await screen.select(workspace: "A") }
    await service.waitUntilRequested("A")

    let selectB = Task { await screen.select(workspace: "B") }
    await service.waitUntilRequested("B")

    await service.complete("B", with: ["b1", "b2"])
    await selectB.value

    await service.complete("A", with: ["a1", "a2"])
    await selectA.value

    return screen.visibleArticles == ["b1", "b2"]
}
