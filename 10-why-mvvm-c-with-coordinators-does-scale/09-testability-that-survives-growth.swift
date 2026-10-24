// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: Testability that survives growth
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#testability-that-survives-growth

@MainActor
func testCheckoutFlow() {
    let coordinator = CheckoutCoordinator()

    coordinator.navigateToShipping()
    coordinator.navigateToPayment()

    assert(coordinator.path.count == 2)

    coordinator.popToRoot()
    assert(coordinator.path.isEmpty)
}
