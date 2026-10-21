// Swift in Practice — Edition #2: Swift Concurrency: What I Wish Someone Had Told Me
// Section: 1. @MainActor Isn't a Magic Thread-Safety Wand
// https://swiftinpractice.pages.dev/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#1-mainactor-isn-t-a-magic-thread-safety-wand

@MainActor
class ViewModel: ObservableObject {
    @Published var data: [Item] = []

    func loadData() async {
        // This compiles, but creates subtle timing issues
        let result = await networkService.fetch()
        self.data = result
    }
}
