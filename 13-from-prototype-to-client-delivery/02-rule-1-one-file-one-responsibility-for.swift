// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: Rule 1: One File, One Responsibility (For Real This Time)
// https://swiftinpractice.pages.dev/editions/13-from-prototype-to-client-delivery/#rule-1-one-file-one-responsibility-for-real-this-time

// LoginViewController.swift - 650 lines of pain

class LoginViewController: UIViewController {

    // UI Setup (100 lines)
    private func setupUI() {
        // Constraint hell here
    }

    // Networking (80 lines)
    private func performLogin() {
        let url = URL(string: "https://api.myapp.com/login")!
        var request = URLRequest(url: url)
        // 60 more lines of URLSession boilerplate
    }

    // Business Logic (120 lines)
    private func validateEmail(_ email: String) -> Bool {
        // Regex validation
    }

    private func validatePassword(_ password: String) -> Bool {
        // Password rules
    }

    // Data Persistence (90 lines)
    private func saveUserSession(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
        // More saving logic
    }

    // Navigation (60 lines)
    // Error Handling (100 lines)
    // Analytics (50 lines)
    // ... you get the idea
}
