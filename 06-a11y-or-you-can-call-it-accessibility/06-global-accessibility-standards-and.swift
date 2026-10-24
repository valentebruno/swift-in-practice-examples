// Swift in Practice — Edition #6: A11y, or You Can Call It Accessibility
// Section: Global Accessibility Standards and Regulations
// https://swiftinpractice.com/editions/6-a11y-or-you-can-call-it-accessibility/#global-accessibility-standards-and-regulations

// In Package.swift
dependencies: [
    .package(
        name: "AccessibilitySnapshot",
        url: "https://github.com/cashapp/AccessibilitySnapshot.git",
        from: "0.4.1"
    ),
]

targets: [
    .testTarget(
        name: "MyAppTests",
        dependencies: [
            "MyApp",
            "AccessibilitySnapshot"
        ]
    )
]
