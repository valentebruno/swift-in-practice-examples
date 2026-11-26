# Edition #22 — When Actors Are Not Enough: Reentrancy and State Ownership

> An actor protects its state between suspension points. Every await is a door, and the decision you made before it may not survive the walk through.

**Read the full edition on Swift in Practice:** https://swiftinpractice.com/editions/22-when-actors-are-not-enough/

Concurrency · Learn · 26 Nov 2026

## Snippets

| File | Language | Section |
|---|---|---|
| [`01-the-store-that-looks-safe.swift`](01-the-store-that-looks-safe.swift) | Swift | [The store that looks safe](https://swiftinpractice.com/editions/22-when-actors-are-not-enough/#the-store-that-looks-safe) |
| [`02-publish-shared-work-before-suspending.swift`](02-publish-shared-work-before-suspending.swift) | Swift | [Publish shared work before suspending](https://swiftinpractice.com/editions/22-when-actors-are-not-enough/#publish-shared-work-before-suspending) |
| [`03-reproduce-the-interleaving.swift`](03-reproduce-the-interleaving.swift) | Swift | [Reproduce the interleaving](https://swiftinpractice.com/editions/22-when-actors-are-not-enough/#reproduce-the-interleaving) |

These are the snippets exactly as they appear in the edition. They are excerpts that rely on the
surrounding explanation, not a buildable project — the edition explains when and why to use each one.

---

[← All editions](../README.md) · [Swift in Practice](https://swiftinpractice.com/) · Code a Brighter Tomorrow.
