// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: Modeling Coordinators in SwiftUI
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#modeling-coordinators-in-swiftui

@MainActor
final class CheckoutCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    enum Destination: Hashable {
        case shipping
        case payment
        case confirmation(orderId: String)
    }

    func navigateToShipping() { path.append(Destination.shipping) }
    func navigateToPayment() { path.append(Destination.payment) }
    func popToRoot() { path = NavigationPath() }
}
