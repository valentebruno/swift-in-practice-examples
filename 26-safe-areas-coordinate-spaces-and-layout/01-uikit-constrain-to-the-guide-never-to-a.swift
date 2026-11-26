// Swift in Practice — Edition #26: When the Left Inset Is Not the Right Inset
// Section: UIKit: constrain to the guide, never to a number
// https://swiftinpractice.com/editions/26-safe-areas-coordinate-spaces-and-layout/#uikit-constrain-to-the-guide-never-to-a-number

import UIKit

@MainActor
final class ReadingViewController: UIViewController {
    private let actionButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        actionButton.setTitle("Continue reading", for: .normal)
        actionButton.titleLabel?.adjustsFontForContentSizeCategory = true
        actionButton.titleLabel?.numberOfLines = 0
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)

        let safeArea = view.safeAreaLayoutGuide
        let aboveKeyboard = actionButton.bottomAnchor.constraint(
            lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor,
            constant: -12
        )
        let restingPosition = actionButton.bottomAnchor.constraint(
            equalTo: safeArea.bottomAnchor,
            constant: -12
        )
        restingPosition.priority = .defaultHigh

        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 20
            ),
            actionButton.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor, constant: -20
            ),
            actionButton.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 44
            ),
            aboveKeyboard,
            restingPosition
        ])
    }
}
