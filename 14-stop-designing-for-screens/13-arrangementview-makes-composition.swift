// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

struct Review: Identifiable, Sendable {
    let id: UUID
    let videoURL: URL
    var notes: String
    var playhead: Duration
}
