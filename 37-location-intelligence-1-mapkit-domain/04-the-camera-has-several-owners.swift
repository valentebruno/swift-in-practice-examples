// Swift in Practice — Edition #37: MapKit Is Not Just a Map
// Section: The camera has several owners
// https://swiftinpractice.com/editions/37-location-intelligence-1-mapkit-domain/#the-camera-has-several-owners

enum CameraMode: Equatable {
    case followingUser
    case free
    case focused(Place.ID)
}

struct PlaceMap: View {
    let places: [Place]
    @Binding var selection: Place.ID?

    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var mode: CameraMode = .followingUser

    var body: some View {
        Map(position: $position, selection: $selection) {
            UserAnnotation()
            ForEach(places) { place in
                Marker(place.name, coordinate: place.coordinate)
                    .tag(place.id)
            }
        }
        .onMapCameraChange(frequency: .onEnd) { _ in
            if position.positionedByUser {
                mode = .free
            }
        }
        .onChange(of: selection) { _, newValue in
            guard let place = places.first(where: { $0.id == newValue }) else { return }
            mode = .focused(place.id)
            position = .region(MKCoordinateRegion(
                center: place.coordinate,
                latitudinalMeters: 800,
                longitudinalMeters: 800
            ))
        }
        .overlay(alignment: .bottomTrailing) {
            if mode != .followingUser {
                Button("Recenter", systemImage: "location") {
                    mode = .followingUser
                    position = .userLocation(fallback: .automatic)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}
