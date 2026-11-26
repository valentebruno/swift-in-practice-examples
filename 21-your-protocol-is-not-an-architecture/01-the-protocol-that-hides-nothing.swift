// Swift in Practice — Edition #21: Your Protocol Is Not an Architecture
// Section: The protocol that hides nothing
// https://swiftinpractice.com/editions/21-your-protocol-is-not-an-architecture/#the-protocol-that-hides-nothing

import Foundation

protocol APIClientProtocol {
    var session: URLSession { get }
    var refreshToken: String? { get set }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
    func paginated(_ request: URLRequest, page: Int) async throws -> (Data, HTTPURLResponse)
}
