// Swift in Practice — Edition #26: When the Left Inset Is Not the Right Inset
// Section: UIKit: constrain to the guide, never to a number
// https://swiftinpractice.com/editions/26-safe-areas-coordinate-spaces-and-layout/#uikit-constrain-to-the-guide-never-to-a-number

final class WaveformViewController: UIViewController {
    private let waveformLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(waveformLayer)
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        view.setNeedsLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        waveformLayer.frame = view.bounds.inset(by: view.safeAreaInsets)
    }
}
