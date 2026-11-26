// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: Cross-cutting concerns inside Coordinators
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#cross-cutting-concerns-inside-coordinators

@MainActor
final class HomeCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let analytics: AnalyticsService
    private let featureFlags: FeatureFlagService

    enum HomeDestination: Hashable {
        case productDetail(String)
        case productDetailV2(String)
    }

    init(analytics: AnalyticsService, featureFlags: FeatureFlagService) {
        self.analytics = analytics
        self.featureFlags = featureFlags
    }

    func navigateToProductDetail(_ product: Product) {
        analytics.track(.productViewed(product.id))

        if featureFlags.isEnabled(.newProductDetailUI) {
            path.append(HomeDestination.productDetailV2(String(describing: product.id)))
        } else {
            path.append(HomeDestination.productDetail(String(describing: product.id)))
        }
    }
}
