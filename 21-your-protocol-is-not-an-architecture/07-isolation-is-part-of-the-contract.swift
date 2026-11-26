// Swift in Practice — Edition #21: Your Protocol Is Not an Architecture
// Section: Isolation is part of the contract
// https://swiftinpractice.com/editions/21-your-protocol-is-not-an-architecture/#isolation-is-part-of-the-contract

protocol Describable {
    func describe() -> String
}

@MainActor
final class StatusBanner {
    var text = "Idle"
}

extension StatusBanner: @MainActor Describable {
    func describe() -> String { text }
}
