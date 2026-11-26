// Swift in Practice — Edition #37: MapKit Is Not Just a Map
// Section: Search results need an acceptance check
// https://swiftinpractice.com/editions/37-location-intelligence-1-mapkit-domain/#search-results-need-an-acceptance-check

@MainActor
@Observable
final class PlaceSearchModel {
    enum Phase: Equatable {
        case idle
        case searching
        case results([Place])
        case failed
    }

    private(set) var phase: Phase = .idle

    private var generation = 0
    private var activeSearch: MKLocalSearch?

    func search(text: String, region: MKCoordinateRegion) async {
        generation += 1
        let token = generation
        activeSearch?.cancel()
        activeSearch = nil

        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            phase = .idle
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region

        let search = MKLocalSearch(request: request)
        activeSearch = search
        phase = .searching

        do {
            let response = try await search.start()
            guard token == generation else { return }
            phase = .results(response.mapItems.map(Place.init))
        } catch {
            guard token == generation else { return }
            phase = .failed
        }
        activeSearch = nil
    }

    func cancel() {
        generation += 1
        activeSearch?.cancel()
        activeSearch = nil
        phase = .idle
    }
}
