// Swift in Practice — Edition #25: Accessibility as an Architectural Constraint
// Section: Keep product meaning in the model
// https://swiftinpractice.com/editions/25-accessibility-as-an-architectural-constraint/#keep-product-meaning-in-the-model

enum OrderStatus: Sendable {
    case ready, preparing, needsAttention

    var title: LocalizedStringResource {
        switch self {
        case .ready: "Ready for pickup"
        case .preparing: "Being prepared"
        case .needsAttention: "Needs attention"
        }
    }

    var symbol: String {
        switch self {
        case .ready: "checkmark.circle"
        case .preparing: "clock"
        case .needsAttention: "exclamationmark.triangle"
        }
    }

    var tint: Color {
        switch self {
        case .ready: .green
        case .preparing: .orange
        case .needsAttention: .red
        }
    }
}

struct OrderStatusBadge: View {
    let status: OrderStatus

    var body: some View {
        Label {
            Text(status.title)
        } icon: {
            Image(systemName: status.symbol)
                .foregroundStyle(status.tint)
                .accessibilityHidden(true)
        }
    }
}
