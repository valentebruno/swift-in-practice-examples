// Swift in Practice — Edition #21: Your Protocol Is Not an Architecture
// Section: Isolation is part of the contract
// https://swiftinpractice.com/editions/21-your-protocol-is-not-an-architecture/#isolation-is-part-of-the-contract

@MainActor
protocol StatusDisplaying: AnyObject, Sendable {
    func show(_ message: String)
}

func report(_ message: String, to display: any StatusDisplaying) async {
    await display.show(message)
}
