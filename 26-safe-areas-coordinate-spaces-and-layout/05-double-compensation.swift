// Swift in Practice — Edition #26: When the Left Inset Is Not the Right Inset
// Section: Double compensation
// https://swiftinpractice.com/editions/26-safe-areas-coordinate-spaces-and-layout/#double-compensation

struct SafeAreaProbe: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { proxy in
                let insets = proxy.safeAreaInsets
                Text(
                    "top \(Int(insets.top))  bottom \(Int(insets.bottom))\n"
                    + "leading \(Int(insets.leading))  trailing \(Int(insets.trailing))\n"
                    + "size \(Int(proxy.size.width)) × \(Int(proxy.size.height))"
                )
                .font(.caption2.monospaced())
                .padding(6)
                .background(.yellow.opacity(0.85))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(false)
            }
        }
    }
}

extension View {
    func safeAreaProbe() -> some View { modifier(SafeAreaProbe()) }
}
