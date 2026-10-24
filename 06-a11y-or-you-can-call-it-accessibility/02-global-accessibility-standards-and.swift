// Swift in Practice — Edition #6: A11y, or You Can Call It Accessibility
// Section: Global Accessibility Standards and Regulations
// https://swiftinpractice.com/editions/6-a11y-or-you-can-call-it-accessibility/#global-accessibility-standards-and-regulations

import UIKit

class LoginViewController: UIViewController {
    let logoImageView = UIImageView(image: UIImage(named: "logo"))
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let forgotPasswordButton = UIButton()
    let errorLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAccessibility()

        // Email field with Dynamic Type
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.font = UIFont.preferredFont(forTextStyle: .body)
        emailTextField.adjustsFontForContentSizeCategory = true
        emailTextField.accessibilityLabel = "Email address"
        emailTextField.accessibilityHint = "Enter your email address"
        emailTextField.accessibilityIdentifier = "emailField"
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.autocapitalizationType = .none

        // Password field with Dynamic Type
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = UIFont.preferredFont(forTextStyle: .body)
        passwordTextField.adjustsFontForContentSizeCategory = true
        passwordTextField.accessibilityLabel = "Password"
        passwordTextField.accessibilityHint = "Enter your password"
        passwordTextField.accessibilityIdentifier = "passwordField"
        passwordTextField.textContentType = .password

        // Login button with clear label
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 8
        loginButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        loginButton.titleLabel?.adjustsFontForContentSizeCategory = true
        loginButton.accessibilityLabel = "Log in"
        loginButton.accessibilityHint = "Double tap to log in with your credentials"
        loginButton.accessibilityIdentifier = "loginButton"
        loginButton.accessibilityTraits = .button
        // Minimum touch target size (44x44pt)
        loginButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

        // Forgot password with proper sizing
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.setTitleColor(.systemBlue, for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        forgotPasswordButton.titleLabel?.adjustsFontForContentSizeCategory = true
        forgotPasswordButton.accessibilityLabel = "Forgot password"
        forgotPasswordButton.accessibilityHint = "Double tap to reset your password"
        forgotPasswordButton.accessibilityIdentifier = "forgotPasswordButton"
        forgotPasswordButton.accessibilityTraits = .button

        // Error label with Dynamic Type
        errorLabel.textColor = .systemRed
        errorLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        errorLabel.adjustsFontForContentSizeCategory = true
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.accessibilityTraits = .staticText
        errorLabel.accessibilityIdentifier = "errorLabel"

        // Layout code...
    }

    func setupAccessibility() {
        // Logo is decorative
        logoImageView.isAccessibilityElement = true
        logoImageView.accessibilityLabel = "Company logo"
        logoImageView.accessibilityTraits = .image

        // Set proper accessibility order
        view.accessibilityElements = [
            logoImageView,
            emailTextField,
            passwordTextField,
            loginButton,
            forgotPasswordButton,
            errorLabel
        ]
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false

        // Announce error to VoiceOver users (iOS 11+)
        UIAccessibility.post(notification: .announcement, argument: "Error: \(message)")

        // Move VoiceOver focus to error
        UIAccessibility.post(notification: .layoutChanged, argument: errorLabel)
    }
}
