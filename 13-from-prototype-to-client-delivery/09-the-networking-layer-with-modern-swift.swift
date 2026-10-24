// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: The Networking Layer (With Modern Swift Concurrency)
// https://swiftinpractice.com/editions/13-from-prototype-to-client-delivery/#the-networking-layer-with-modern-swift-concurrency

let user: User = try await apiClient.request(.fetchProfile)

let credentials = LoginCredentials(email: email, password: password)
let session: AuthSession = try await apiClient.request(.login(credentials))
