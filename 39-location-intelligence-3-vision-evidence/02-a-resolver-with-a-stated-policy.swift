// Swift in Practice — Edition #39: From Camera Frame to Map Pin
// Section: A resolver with a stated policy
// https://swiftinpractice.com/editions/39-location-intelligence-3-vision-evidence/#a-resolver-with-a-stated-policy

struct ResolutionPolicy: Sendable {
    let minimumScore: Float
    let maximumDistanceMeters: Double
    let maximumChoices: Int
}

func resolvePlace(
    classifications: [VisualClassification],
    catalog: [CatalogPlace],
    distanceToPlace: (CatalogPlace) -> Double?,
    policy: ResolutionPolicy
) -> PlaceResolution {
    var candidates: [PlaceCandidate] = []

    for classification in classifications
    where classification.score >= policy.minimumScore {
        for place in catalog where place.labels.contains(classification.label) {
            let distance = distanceToPlace(place)
            if let distance, distance > policy.maximumDistanceMeters { continue }
            candidates.append(PlaceCandidate(
                place: place,
                classification: classification,
                distanceMeters: distance
            ))
        }
    }

    var seen = Set<String>()
    let unique = candidates
        .sorted { $0.classification.score > $1.classification.score }
        .filter { seen.insert($0.place.id).inserted }

    switch unique.count {
    case 0:
        return .unknown
    case 1:
        return .match(unique[0])
    default:
        return .choices(Array(unique.prefix(policy.maximumChoices)))
    }
}
