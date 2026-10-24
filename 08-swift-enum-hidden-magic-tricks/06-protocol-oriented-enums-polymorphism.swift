// Swift in Practice — Edition #8: Swift Enum Hidden Magic Tricks
// Section: Protocol-Oriented Enums: Polymorphism Without Inheritance
// https://swiftinpractice.com/editions/8-swift-enum-hidden-magic-tricks/#protocol-oriented-enums-polymorphism-without-inheritance

protocol FeatureDisplayable {
    var title: String { get }
}

enum Feature: FeatureDisplayable {
    case profile
    case settings(hasUpdates: Bool)
    case help

    var title: String {
        switch self {
        case .profile:
            return "User Profile"
        case .settings(let hasUpdates):
            return hasUpdates ? "Settings (New!)" : "Settings"
        case .help:
            return "Help & Support"
        }
    }
}
