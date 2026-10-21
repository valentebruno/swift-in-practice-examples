// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: Documentation That Actually Helps Future You
// https://swiftinpractice.pages.dev/editions/13-from-prototype-to-client-delivery/#documentation-that-actually-helps-future-you

// Using white background instead of system background because
// QR code scanner needs high contrast to work reliably in both modes
view.backgroundColor = .white

// Delay required to avoid race condition with keyboard dismiss animation
// Context: iOS 17.0 introduced a timing issue where rapid transitions
// cause the keyboard to re-appear. This workaround will be removed
// when we drop iOS 16 support.
// See: https://github.com/myapp/issues/234
try? await Task.sleep(for: .milliseconds(300))

// Temporary workaround: API returns birthdate in multiple formats
// Backend team is migrating to ISO8601 (tracking: BACK-456)
// TODO: Remove after backend migration completes
let date = parseFlexibleDateFormat(dateString)
