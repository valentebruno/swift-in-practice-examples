// Swift in Practice — Edition #10: Why MVVM-C with Coordinators Does Scale
// Section: Coordinators owning business logic
// https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#coordinators-owning-business-logic

// ❌ Wrong: Business logic in Coordinator
coordinator.navigate { user in
    if user.balance > amount {
        path.append(.checkout)
    } else {
        path.append(.insufficientFunds)
    }
}
