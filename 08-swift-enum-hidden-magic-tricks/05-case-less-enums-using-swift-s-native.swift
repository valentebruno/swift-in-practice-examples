// Swift in Practice — Edition #8: Swift Enum Hidden Magic Tricks
// Section: Case-Less Enums: Using Swift’s Native Namespace Tool
// https://swiftinpractice.com/editions/8-swift-enum-hidden-magic-tricks/#case-less-enums-using-swift-s-native-namespace-tool

switch state {
case .idle:
    showPlaceholder()
case .loading:
    showSpinner()
case .loaded(let users):
    show(users)
case .failed(let err):
    showError(err.localizedDescription)
}
