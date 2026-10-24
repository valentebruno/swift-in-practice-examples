// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: The Networking Layer (With Modern Swift Concurrency)
// https://swiftinpractice.com/editions/13-from-prototype-to-client-delivery/#the-networking-layer-with-modern-swift-concurrency

// LoginViewModel.swift
func login(email: String, password: String) async {
    guard let url = URL(string: "https://api.myapp.com/auth/login") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    // ... 40 more lines of duplication
}
