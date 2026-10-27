# Edition #10 — Why MVVM-C with Coordinators Does Scale

> MVVM-C scales when coordinators own navigation and business rules stay in view models or domain use cases — a real-world SwiftUI perspective.

**Read the full edition on Swift in Practice:** https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/

Architecture · Learn · 23 Jan 2026

## Snippets

| File | Language | Section |
|---|---|---|
| [`01-the-god-coordinator.swift`](01-the-god-coordinator.swift) | Swift | [The God Coordinator](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#the-god-coordinator) |
| [`02-coordinators-owning-business-logic.swift`](02-coordinators-owning-business-logic.swift) | Swift | [Coordinators owning business logic](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#coordinators-owning-business-logic) |
| [`03-coordinators-owning-business-logic.swift`](03-coordinators-owning-business-logic.swift) | Swift | [Coordinators owning business logic](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#coordinators-owning-business-logic) |
| [`04-tight-coupling-through-concrete.swift`](04-tight-coupling-through-concrete.swift) | Swift | [Tight coupling through concrete dependencies](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#tight-coupling-through-concrete-dependencies) |
| [`05-tight-coupling-through-concrete.swift`](05-tight-coupling-through-concrete.swift) | Swift | [Tight coupling through concrete dependencies](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#tight-coupling-through-concrete-dependencies) |
| [`06-no-real-feature-boundaries.txt`](06-no-real-feature-boundaries.txt) | Text | [No real feature boundaries](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#no-real-feature-boundaries) |
| [`07-modeling-coordinators-in-swiftui.swift`](07-modeling-coordinators-in-swiftui.swift) | Swift | [Modeling Coordinators in SwiftUI](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#modeling-coordinators-in-swiftui) |
| [`08-integration-with-views.swift`](08-integration-with-views.swift) | Swift | [Integration with Views](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#integration-with-views) |
| [`09-testability-that-survives-growth.swift`](09-testability-that-survives-growth.swift) | Swift | [Testability that survives growth](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#testability-that-survives-growth) |
| [`10-cross-cutting-concerns-inside.swift`](10-cross-cutting-concerns-inside.swift) | Swift | [Cross-cutting concerns inside Coordinators](https://swiftinpractice.com/editions/10-why-mvvm-c-with-coordinators-does-scale/#cross-cutting-concerns-inside-coordinators) |

These are the snippets exactly as they appear in the edition. They are excerpts that rely on the
surrounding explanation, not a buildable project — the edition explains when and why to use each one.

---

[← All editions](../README.md) · [Swift in Practice](https://swiftinpractice.com/) · Code a Brighter Tomorrow.
