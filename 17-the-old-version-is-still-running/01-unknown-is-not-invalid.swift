// Swift in Practice — Edition #17: The Old Version Is Still Running
// Section: Unknown is not invalid
// https://swiftinpractice.com/editions/17-the-old-version-is-still-running/#unknown-is-not-invalid

enum RecipeStatus: Sendable, Equatable {
    case draft, published
    case unrecognized(String)

    var rawValue: String {
        switch self {
        case .draft: "draft"
        case .published: "published"
        case .unrecognized(let raw): raw
        }
    }
}

extension RecipeStatus: Codable {
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        switch raw {
        case "draft": self = .draft
        case "published": self = .published
        default: self = .unrecognized(raw)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
