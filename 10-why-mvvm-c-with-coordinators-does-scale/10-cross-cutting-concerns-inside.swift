// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: Cross-cutting concerns inside Coordinators
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#cross-cutting-concerns-inside-coordinators

@MainActor
final class HomeCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let analytics: AnalyticsService
    private let featureFlags: FeatureFlagService

    func navigateToProductDetail(_ product: Product) {
        analytics.track(.productViewed(product.id))

        if featureFlags.isEnabled(.newProductDetailUI) {
            path.append(.productDetailV2(product))
        } else {
            path.append(.productDetail(product))
        }
    }
}
