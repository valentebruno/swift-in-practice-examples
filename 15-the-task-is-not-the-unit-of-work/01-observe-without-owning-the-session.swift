// Swift in Practice — Edition #15: The Task Is Not the Unit of Work
// https://swiftinpractice.com/editions/15-the-task-is-not-the-unit-of-work/

import SwiftUI

struct SessionReadout: View {
    let sessionID: UUID
    let observe: (UUID) -> AsyncStream<String>
    @State private var text = "Connecting…"

    var body: some View {
        Text(text)
            .task(id: sessionID) {
                text = "Connecting…"
                for await value in observe(sessionID) {
                    guard !Task.isCancelled else { return }
                    text = value
                }
            }
    }
}
