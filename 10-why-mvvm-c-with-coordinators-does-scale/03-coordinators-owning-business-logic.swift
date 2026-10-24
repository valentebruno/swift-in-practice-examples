// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: Coordinators owning business logic
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#coordinators-owning-business-logic

// ✅ Correct: Business logic in ViewModel
@MainActor
final class CheckoutViewModel: ObservableObject {
    private let coordinator: CheckoutCoordinating
    @Published var canProceed: Bool = false

    init(coordinator: CheckoutCoordinating) {
        self.coordinator = coordinator
    }

    func proceedToPayment() {
        if canProceed {
            coordinator.navigateToPayment()
        } else {
            showInsufficientFundsAlert()
        }
    }

    private func showInsufficientFundsAlert() {
        print("Insufficient funds")
    }
}
