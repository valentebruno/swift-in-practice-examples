// Swift in Practice — Edition #6: A11y, or You Can Call It Accessibility
// Section: Global Accessibility Standards and Regulations
// https://swiftinpractice.pages.dev/editions/6-a11y-or-you-can-call-it-accessibility/#global-accessibility-standards-and-regulations

import AccessibilitySnapshot
import XCTest

class LoginViewAccessibilityTests: XCTestCase {
    func testLoginViewAccessibility() {
        let loginView = LoginView()
        loginView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

        // Generate accessibility snapshot
        assertSnapshot(matching: loginView, as: .accessibilityImage)
    }

    func testLoginViewWithActivationPoints() {
        let loginView = LoginView()
        loginView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

        // Show activation points for all elements
        assertSnapshot(
            matching: loginView,
            as: .accessibilityImage(showActivationPoints: .always)
        )
    }

    // Test with Dynamic Type
    func testLoginViewWithLargeText() {
        let loginView = LoginView()
        loginView.traitCollection = UITraitCollection(
            preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge
        )

        assertSnapshot(
            matching: loginView,
            as: .accessibilityImage,
            named: "xxxlarge-text"
        )
    }
}
