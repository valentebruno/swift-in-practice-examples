// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: Configuration: Environment-Aware From Day One
// https://swiftinpractice.pages.dev/editions/13-from-prototype-to-client-delivery/#configuration-environment-aware-from-day-one

enum Environment: Sendable {
    case development
    case staging
    case production

    var baseURL: String {
        switch self {
        case .development: return "http://localhost:8000"
        case .staging: return "https://staging-api.myapp.com"
        case .production: return "https://api.myapp.com"
        }
    }

    var apiKey: String {
        switch self {
        case .development: return "dev_key_12345"
        case .staging: return "staging_key_67890"
        case .production: return "prod_key_real"
        }
    }

    var features: FeatureFlags {
        switch self {
        case .development:
            return FeatureFlags(debugMenu: true, analyticsEnabled: false)
        case .staging:
            return FeatureFlags(debugMenu: true, analyticsEnabled: true)
        case .production:
            return FeatureFlags(debugMenu: false, analyticsEnabled: true)
        }
    }
}

struct FeatureFlags: Sendable {
    let debugMenu: Bool
    let analyticsEnabled: Bool
}

struct AppConfig: Sendable {
    static let current: Environment = {
        #if DEBUG
        return .development
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }()
}

// Usage:
let client = APIClient(baseURL: AppConfig.current.baseURL)
