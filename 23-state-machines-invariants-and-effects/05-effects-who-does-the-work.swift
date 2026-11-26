// Swift in Practice — Edition #23: Your App Has More States Than Your Model Admits
// Section: Effects: who does the work
// https://swiftinpractice.com/editions/23-state-machines-invariants-and-effects/#effects-who-does-the-work

protocol UploadClient: Sendable {
    func transfer(attempt: UUID) async throws -> String
    func verify(remoteID: String) async throws
}

@MainActor
@Observable
final class UploadController {
    private(set) var state: UploadState = .idle

    private let client: any UploadClient
    private var tasks: [UUID: Task<Void, Never>] = [:]

    init(client: any UploadClient) {
        self.client = client
    }

    func send(_ event: UploadEvent) {
        let result = step(state, event)
        state = result.state
        for effect in result.effects {
            run(effect)
        }
    }

    private func run(_ effect: UploadEffect) {
        switch effect {
        case .startTransfer(let attempt):
            tasks[attempt] = Task { [client] in
                do {
                    let remoteID = try await client.transfer(attempt: attempt)
                    send(.transferred(attempt: attempt, remoteID: remoteID))
                } catch {
                    send(.failed(attempt: attempt, reason: "Transfer failed"))
                }
            }

        case .startVerification(let attempt, let remoteID):
            tasks[attempt] = Task { [client] in
                do {
                    try await client.verify(remoteID: remoteID)
                    send(.verified(attempt: attempt, remoteID: remoteID))
                    tasks[attempt] = nil
                } catch {
                    send(.failed(attempt: attempt, reason: "Verification failed"))
                }
            }

        case .cancelWork(let attempt):
            tasks.removeValue(forKey: attempt)?.cancel()
        }
    }
}
