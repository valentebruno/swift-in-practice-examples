// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: Tight coupling through concrete dependencies
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#tight-coupling-through-concrete-dependencies

// ❌ Wrong
final class HomeViewModel {
    let coordinator: HomeCoordinator
}
