// Swift in Practice — Edition #26: When the Left Inset Is Not the Right Inset
// Section: Leading is a reading direction; left is a side of the glass
// https://swiftinpractice.com/editions/26-safe-areas-coordinate-spaces-and-layout/#leading-is-a-reading-direction-left-is-a-side-of-the-glass

extension NSDirectionalEdgeInsets {
    init(_ insets: UIEdgeInsets, layoutDirection: UITraitEnvironmentLayoutDirection) {
        let isRightToLeft = layoutDirection == .rightToLeft
        self.init(
            top: insets.top,
            leading: isRightToLeft ? insets.right : insets.left,
            bottom: insets.bottom,
            trailing: isRightToLeft ? insets.left : insets.right
        )
    }
}
