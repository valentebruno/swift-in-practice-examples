// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

import Observation

struct Review: Identifiable, Sendable {
    let id: UUID
    let videoURL: URL
    var playhead: Duration
    var notes: String
}

enum ReviewAction: Sendable {
    case seek(Duration)
    case updateNotes(String)
    case showTools
    case hideTools
}
