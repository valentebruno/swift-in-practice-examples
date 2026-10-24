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

        // Email field - fixed size
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.font = UIFont.systemFont(ofSize: 14)

        // Password field - fixed size
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = UIFont.systemFont(ofSize: 14)

        // Login button - unclear label
        loginButton.setTitle("→", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 8

        // Forgot password - too small
        forgotPasswordButton.setTitle("Forgot?", for: .normal)
        forgotPasswordButton.setTitleColor(.systemBlue, for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        // Error label - fixed size
        errorLabel.textColor = .red
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        // Layout code...
    }
}
