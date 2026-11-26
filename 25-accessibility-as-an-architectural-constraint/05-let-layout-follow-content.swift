// Swift in Practice — Edition #25: Accessibility as an Architectural Constraint
// Section: Let layout follow content
// https://swiftinpractice.com/editions/25-accessibility-as-an-architectural-constraint/#let-layout-follow-content

struct OrderSummary: View {
    let order: Order
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        let layout = typeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8))
            : AnyLayout(HStackLayout(spacing: 16))

        layout {
            Text("Order \(order.id)")
            Text(order.customer)
            OrderStatusBadge(status: order.status)
        }
    }
}
