// Swift in Practice — Edition #25: Accessibility as an Architectural Constraint
// Section: Build the interaction around a command
// https://swiftinpractice.com/editions/25-accessibility-as-an-architectural-constraint/#build-the-interaction-around-a-command

struct Dashboard: View {
    @State private var orders: [Order] = []
    @State private var selection: Order.ID?

    var body: some View {
        List(orders, selection: $selection) { order in
            OrderRow(order: order) { markCollected(order.id) }
        }
        .focusedSceneValue(
            \.markSelectedOrderCollected,
            selection.flatMap { id in
                orders.contains(where: { $0.id == id }) ? { markCollected(id) } : nil
            }
        )
    }

    private func markCollected(_ id: Order.ID) {
        guard let index = orders.firstIndex(where: { $0.id == id }) else { return }
        orders.remove(at: index)       // stands in for the real command
        if selection == id { selection = nil }
    }
}
