// Swift in Practice — Edition #3: Swift 6 Migration Playbook: How We Moved Three Production Apps Without Halting Feature Delivery
// Section: Three ground rules
// https://swiftinpractice.com/editions/3-swift-6-migration-playbook/#three-ground-rules

@MainActor
final class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    private let service: UserService

    init(service: UserService) {
        self.service = service
    }

    func fetchUsers() async {
        do {
            users = try await service.load()
        } catch {
            print("Error: \(error)")
        }
    }
}
