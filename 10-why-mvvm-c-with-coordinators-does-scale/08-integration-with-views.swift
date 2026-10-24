// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: Integration with Views
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#integration-with-views

struct CheckoutCoordinatorView: View {
    @StateObject private var coordinator = CheckoutCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            CheckoutCartView(viewModel: CheckoutCartViewModel(coordinator: coordinator))
                .navigationDestination(for: CheckoutCoordinator.Destination.self) { destination in
                    switch destination {
                    case .shipping:
                        ShippingView(viewModel: ShippingViewModel(coordinator: coordinator))
                    case .payment:
                        PaymentView(viewModel: PaymentViewModel(coordinator: coordinator))
                    case .confirmation(let orderId):
                        ConfirmationView(orderId: orderId)
                    }
                }
        }
    }
}
