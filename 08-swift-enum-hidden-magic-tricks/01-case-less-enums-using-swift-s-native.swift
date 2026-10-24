// Swift in Practice — Edition #8: Swift Enum Hidden Magic Tricks
// Section: Case-Less Enums: Using Swift’s Native Namespace Tool
// https://swiftinpractice.com/editions/8-swift-enum-hidden-magic-tricks/#case-less-enums-using-swift-s-native-namespace-tool

//
//  Created by Bruno Valente on 06/12/2025.
final class AppConfig {
    private init() {}
    static let apiBaseURL = URL(string: "https://api.production.com")!
}
