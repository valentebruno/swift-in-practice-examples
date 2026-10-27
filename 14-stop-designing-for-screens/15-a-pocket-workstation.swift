// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: A pocket workstation?
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#a-pocket-workstation

GuitarView(pitchBend: pitchBend)
    .onHingeChange { _, context in
        // A nil hinge means this device has none.
        // Always check.
        guard let hinge = context.hinge,
              hinge.status == .partiallyOpen else {
            pitchBend = 0
            return
        }
        pitchBend = bend(for: hinge.angle)
    }
