// Swift in Practice — Edition #27: A Fold Shouldn’t Restart Playback
// Section: Geometry tells you the space; the hinge tells you the angle
// https://swiftinpractice.com/editions/27-audio-continuity-across-layout-changes/#geometry-tells-you-the-space-the-hinge-tells-you-the-angle

@available(iOS 27.1, *)
struct HingeExpression: ViewModifier {
    let session: PlaybackSession

    func body(content: Content) -> some View {
        content.onHingeChange { _, context in
            guard let hinge = context.hinge,
                  hinge.status == .partiallyOpen else {
                session.setExpression(nil)
                return
            }
            session.setExpression(hinge.angle.degrees / 180)
        }
    }
}
