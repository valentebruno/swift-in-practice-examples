// Swift in Practice — Edition #25: Accessibility as an Architectural Constraint
// Section: Build the interaction around a command
// https://swiftinpractice.com/editions/25-accessibility-as-an-architectural-constraint/#build-the-interaction-around-a-command

struct Order: Identifiable, Sendable {
    let id: Int
    let customer: String
    var status: OrderStatus
}

struct OrderRow: View {
    let order: Order
    let markCollected: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Order \(order.id)").font(.headline)
                Text(order.customer).foregroundStyle(.secondary)
            }
            Spacer()
            OrderStatusBadge(status: order.status)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAction(named: "Mark collected", markCollected)
        .swipeActions {
            Button("Mark collected", action: markCollected)
        }
    }
}

extension FocusedValues {
    @Entry var markSelectedOrderCollected: (() -> Void)?
}

struct OrderCommands: Commands {
    @FocusedValue(\.markSelectedOrderCollected) private var markCollected

    var body: some Commands {
        CommandMenu("Order") {
            Button("Mark Collected") { markCollected?() }
                .keyboardShortcut("k", modifiers: .command)
                .disabled(markCollected == nil)
        }
    }
}
