// Swift in Practice — Edition #6: A11y, or You Can Call It Accessibility
// Section: Global Accessibility Standards and Regulations
// https://swiftinpractice.pages.dev/editions/6-a11y-or-you-can-call-it-accessibility/#global-accessibility-standards-and-regulations

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showError = false

    var body: some View {
        VStack(spacing: 20) {
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 14))

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 14))

            Button(action: login) {
                Text("→")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            Button("Forgot?") {
                // Forgot password action
            }
            .font(.system(size: 12))

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 12))
            }
        }
        .padding()
    }

    func login() {
        // Login logic
    }
}
