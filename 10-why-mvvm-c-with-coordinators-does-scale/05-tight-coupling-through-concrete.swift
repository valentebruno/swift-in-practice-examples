// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: Tight coupling through concrete dependencies
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#tight-coupling-through-concrete-dependencies

// ✅ Correct: Protocol-based abstraction
protocol HomeCoordinating {
    func navigateToProductDetail(_ product: Product)
    func navigateToCart()
}

@MainActor
final class HomeViewModel: ObservableObject {
    private let coordinator: HomeCoordinating

    init(coordinator: HomeCoordinating) {
        self.coordinator = coordinator
    }

    func showProduct(_ product: Product) {
        coordinator.navigateToProductDetail(product)
    }
}
