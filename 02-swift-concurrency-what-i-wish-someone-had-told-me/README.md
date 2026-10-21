# Edition #2 — Swift Concurrency: What I Wish Someone Had Told Me

> Hard-won lessons from migrating three production apps to Swift 6's strict concurrency model: what @MainActor doesn't protect, and how actor reentrancy hides in code that looks clean.

**Read the full edition on Swift in Practice:** https://swiftinpractice.pages.dev/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/

Concurrency · Learn · 15 Oct 2025

## Snippets

| File | Language | Section |
|---|---|---|
| [`01-mainactor-isn-t-a-magic-thread-safety.swift`](01-mainactor-isn-t-a-magic-thread-safety.swift) | Swift | [1. @MainActor Isn't a Magic Thread-Safety Wand](https://swiftinpractice.pages.dev/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#1-mainactor-isn-t-a-magic-thread-safety-wand) |
| [`02-actor-reentrancy-the-bug-that-looks-like.swift`](02-actor-reentrancy-the-bug-that-looks-like.swift) | Swift | [3. Actor Reentrancy: The Bug That Looks Like Clean Code](https://swiftinpractice.pages.dev/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#3-actor-reentrancy-the-bug-that-looks-like-clean-code) |
| [`03-actor-reentrancy-the-bug-that-looks-like.swift`](03-actor-reentrancy-the-bug-that-looks-like.swift) | Swift | [3. Actor Reentrancy: The Bug That Looks Like Clean Code](https://swiftinpractice.pages.dev/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#3-actor-reentrancy-the-bug-that-looks-like-clean-code) |
| [`04-actor-reentrancy-the-bug-that-looks-like.swift`](04-actor-reentrancy-the-bug-that-looks-like.swift) | Swift | [3. Actor Reentrancy: The Bug That Looks Like Clean Code](https://swiftinpractice.pages.dev/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#3-actor-reentrancy-the-bug-that-looks-like-clean-code) |
| [`05-testing-where-confidence-goes-to-die.swift`](05-testing-where-confidence-goes-to-die.swift) | Swift | [4. Testing: Where Confidence Goes to Die](https://swiftinpractice.pages.dev/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#4-testing-where-confidence-goes-to-die) |

These are the snippets exactly as they appear in the edition. They are excerpts that rely on the
surrounding explanation, not a buildable project — the edition explains when and why to use each one.

---

[← All editions](../README.md) · [Swift in Practice](https://swiftinpractice.pages.dev/) · Code a Brighter Tomorrow.
