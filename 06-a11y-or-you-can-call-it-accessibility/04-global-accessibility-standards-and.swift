// Swift in Practice — Edition #6: A11y, or You Can Call It Accessibility
// Section: Global Accessibility Standards and Regulations
// https://swiftinpractice.pages.dev/editions/6-a11y-or-you-can-call-it-accessibility/#global-accessibility-standards-and-regulations

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @AccessibilityFocusState private var isErrorFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
                .accessibilityLabel("Company logo")
                .accessibilityAddTraits(.isImage)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .accessibilityLabel("Email address")
                .accessibilityHint("Enter your email address")

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
                .textContentType(.password)
                .accessibilityLabel("Password")
                .accessibilityHint("Enter your password")

            Button(action: login) {
                Text("Log In")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44) // Minimum touch target
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .accessibilityLabel("Log in")
            .accessibilityHint("Double tap to log in with your credentials")

            Button(action: { /* Forgot password */ }) {
                Text("Forgot Password?")
            }
            .font(.callout)
            .accessibilityLabel("Forgot password")
            .accessibilityHint("Double tap to reset your password")

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isStaticText)
                    .accessibilityFocused($isErrorFocused)
            }
        }
        .padding()
        .onChange(of: showError) { newValue in
            if newValue {
                // Move VoiceOver focus to error message
                isErrorFocused = true
            }
        }
    }

    func login() {
        // Login logic
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please enter both email and password"
            showError = true
        }
    }
}
