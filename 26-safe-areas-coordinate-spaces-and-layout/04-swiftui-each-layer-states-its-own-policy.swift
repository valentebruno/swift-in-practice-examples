// Swift in Practice — Edition #26: When the Left Inset Is Not the Right Inset
// Section: SwiftUI: each layer states its own policy
// https://swiftinpractice.com/editions/26-safe-areas-coordinate-spaces-and-layout/#swiftui-each-layer-states-its-own-policy

import SwiftUI

struct Paragraph: Identifiable {
    let id: UUID
    let text: String
}

struct ReadingScreen: View {
    let paragraphs: [Paragraph]
    let continueReading: () -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 18) {
                ForEach(paragraphs) { paragraph in
                    Text(paragraph.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: 680)
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .background {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button("Continue reading", action: continueReading)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.bar)
        }
    }
}
