// Swift in Practice — Edition #17: The Old Version Is Still Running
// Section: Round-trip what you do not understand
// https://swiftinpractice.com/editions/17-the-old-version-is-still-running/#round-trip-what-you-do-not-understand

import Foundation

enum JSONValue: Codable, Equatable, Sendable {
    case string(String), number(Double), bool(Bool)
    case array([JSONValue]), object([String: JSONValue]), null

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil() { self = .null }
        else if let v = try? c.decode(Bool.self) { self = .bool(v) }
        else if let v = try? c.decode(Double.self) { self = .number(v) }
        else if let v = try? c.decode(String.self) { self = .string(v) }
        else if let v = try? c.decode([JSONValue].self) { self = .array(v) }
        else { self = .object(try c.decode([String: JSONValue].self)) }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .string(let v): try c.encode(v)
        case .number(let v): try c.encode(v)
        case .bool(let v): try c.encode(v)
        case .array(let v): try c.encode(v)
        case .object(let v): try c.encode(v)
        case .null: try c.encodeNil()
        }
    }
}

struct FieldKey: CodingKey {
    let stringValue: String
    var intValue: Int? { nil }
    init(_ name: String) { stringValue = name }
    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { return nil }
}

struct Recipe: Codable, Equatable, Sendable {
    var id: UUID
    var title: String
    var status: RecipeStatus
    var writtenBySchema: Int
    private(set) var fieldsFromNewerVersions: [String: JSONValue] = [:]

    static let currentSchema = 3
    private static let knownFields: Set<String> =
        ["id", "title", "status", "writtenBySchema"]

    init(id: UUID, title: String, status: RecipeStatus) {
        self.id = id
        self.title = title
        self.status = status
        self.writtenBySchema = Self.currentSchema
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: FieldKey.self)
        id = try c.decode(UUID.self, forKey: FieldKey("id"))
        title = try c.decode(String.self, forKey: FieldKey("title"))
        status = try c.decode(RecipeStatus.self, forKey: FieldKey("status"))
        writtenBySchema = try c.decodeIfPresent(
            Int.self, forKey: FieldKey("writtenBySchema")) ?? 1

        for key in c.allKeys where !Self.knownFields.contains(key.stringValue) {
            fieldsFromNewerVersions[key.stringValue] =
                try c.decode(JSONValue.self, forKey: key)
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: FieldKey.self)
        for (name, value) in fieldsFromNewerVersions {
            try c.encode(value, forKey: FieldKey(name))
        }
        try c.encode(id, forKey: FieldKey("id"))
        try c.encode(title, forKey: FieldKey("title"))
        try c.encode(status, forKey: FieldKey("status"))
        try c.encode(Self.currentSchema, forKey: FieldKey("writtenBySchema"))
    }
}
