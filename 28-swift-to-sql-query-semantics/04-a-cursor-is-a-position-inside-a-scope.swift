// Swift in Practice — Edition #28: From Swift to SQL: Preserving the Meaning of Your Query
// Section: A cursor is a position inside a scope
// https://swiftinpractice.com/editions/28-swift-to-sql-query-semantics/#a-cursor-is-a-position-inside-a-scope

import CryptoKit

struct FeedCursorPayload: Codable, Equatable, Sendable {
    let version: Int
    let workspaceID: UUID
    let filter: String
    let publishedAtMicroseconds: Int64
    let id: UUID
}

enum CursorError: Error, Equatable {
    case malformed, tampered, wrongScope
}

struct CursorCodec: Sendable {
    let key: SymmetricKey

    func encode(_ payload: FeedCursorPayload) throws -> String {
        let body = try JSONEncoder().encode(payload)
        let mac = HMAC<SHA256>.authenticationCode(for: body, using: key)
        return (body + Data(mac)).base64EncodedString()
    }

    func decode(_ cursor: String, for scope: FeedScope) throws -> FeedCursorPayload {
        guard let raw = Data(base64Encoded: cursor),
              raw.count > SHA256.byteCount else {
            throw CursorError.malformed
        }
        let body = raw.dropLast(SHA256.byteCount)
        let mac = raw.suffix(SHA256.byteCount)

        guard HMAC<SHA256>.isValidAuthenticationCode(
            mac, authenticating: body, using: key
        ) else {
            throw CursorError.tampered
        }
        guard let payload = try? JSONDecoder().decode(
            FeedCursorPayload.self, from: body
        ) else {
            throw CursorError.malformed
        }
        guard payload.version == 1,
              payload.workspaceID == scope.workspaceID,
              payload.filter == scope.filter else {
            throw CursorError.wrongScope
        }
        return payload
    }
}
