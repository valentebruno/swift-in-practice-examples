// Swift in Practice — Edition #29: From Swift to GraphQL: Understanding the Work Behind a Request
// Section: HTTP 200 is not a successful screen
// https://swiftinpractice.com/editions/29-swift-to-graphql-execution-contracts/#http-200-is-not-a-successful-screen

import Foundation

enum PathComponent: Decodable, Equatable, Sendable {
    case field(String)
    case index(Int)

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let index = try? container.decode(Int.self) {
            self = .index(index)
        } else {
            self = .field(try container.decode(String.self))
        }
    }
}

struct GraphQLError: Decodable, Sendable {
    struct Extensions: Decodable, Sendable {
        let code: String?
    }

    let message: String
    let path: [PathComponent]?
    let extensions: Extensions?
}

struct GraphQLResponse<Payload: Decodable & Sendable>: Decodable, Sendable {
    let data: Payload?
    let errors: [GraphQLError]?
}

struct ReadingListData: Decodable, Sendable {
    struct Connection: Decodable, Sendable { let edges: [Edge] }
    struct Edge: Decodable, Sendable { let node: Node }
    struct Node: Decodable, Sendable {
        let id: String
        let title: String
        let author: Author?
    }
    struct Author: Decodable, Sendable { let displayName: String }

    let articles: Connection?
}
