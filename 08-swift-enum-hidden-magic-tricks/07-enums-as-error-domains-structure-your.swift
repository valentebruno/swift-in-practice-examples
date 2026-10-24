// Swift in Practice — Edition #8: Swift Enum Hidden Magic Tricks
// Section: Enums as Error Domains: Structure Your Failures
// https://swiftinpractice.com/editions/8-swift-enum-hidden-magic-tricks/#enums-as-error-domains-structure-your-failures

enum NetworkError: Error {
    case invalidResponse
    case timeout
    case connectivity
    case server(code: Int, message: String)

    var isRetryable: Bool {
        switch self {
        case .timeout, .connectivity:
            return true
        default:
            return false
        }
    }
}
