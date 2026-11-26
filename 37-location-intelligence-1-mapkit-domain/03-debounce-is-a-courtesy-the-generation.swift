// Swift in Practice — Edition #37: MapKit Is Not Just a Map
// Section: Debounce is a courtesy; the generation check is the guarantee
// https://swiftinpractice.com/editions/37-location-intelligence-1-mapkit-domain/#debounce-is-a-courtesy-the-generation-check-is-the-guarantee

struct PlaceSearchField: View {
    let model: PlaceSearchModel
    let region: MKCoordinateRegion
    @State private var text = ""

    var body: some View {
        TextField("Search places", text: $text)
            .task(id: text) {
                do {
                    try await Task.sleep(for: .milliseconds(300))
                } catch {
                    return
                }
                await model.search(text: text, region: region)
            }
            .onDisappear { model.cancel() }
    }
}
