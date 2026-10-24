// Swift in Practice — Edition #8: Swift Enum Hidden Magic Tricks
// Section: Case-Less Enums: Using Swift’s Native Namespace Tool
// https://swiftinpractice.com/editions/8-swift-enum-hidden-magic-tricks/#case-less-enums-using-swift-s-native-namespace-tool

enum AppConfig {
    static let apiBaseURL: URL = {
        guard let url = URL(string: "https://api.production.com") else {
            fatalError("Invalid base URL configuration")
        }
        return url
    }()

    enum Logging {
        static let enabled = true
    }
}
