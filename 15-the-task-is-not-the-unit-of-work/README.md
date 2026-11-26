# Edition #15 — The Task Is Not the Unit of Work — Ownership, Isolation, and Cancellation Beyond async/await

> Swift's concurrency checks make code thread-safe, but who owns an operation and how long it lives are architectural decisions — not something to inherit from a view's lifecycle.

**Read the full edition on Swift in Practice:** https://swiftinpractice.com/editions/15-the-task-is-not-the-unit-of-work/

Concurrency · Learn · 6 Oct 2026

## Snippets

| File | Language | Example |
|---|---|---|
| [01-observe-without-owning-the-session.swift](01-observe-without-owning-the-session.swift) | Swift | Cancel the view’s observation while leaving the session with its owner |

These are the snippets exactly as they appear in the edition. They are excerpts that rely on the
surrounding explanation, not a buildable project — the edition explains when and why to use each one.

---

[← All editions](../README.md) · [Swift in Practice](https://swiftinpractice.com/) · Code a Brighter Tomorrow.
