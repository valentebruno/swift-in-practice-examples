// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: The God Coordinator
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#the-god-coordinator

final class AppCoordinator {
    func goToLogin() {}
    func goToHome() {}
    func goToProfile() {}
    func goToCheckout() {}
    func goToTransfer() {}
    func goToSettings() {}
    func goToSupport() {}
    func goToAnalytics() {}
    // … dozens more
}
