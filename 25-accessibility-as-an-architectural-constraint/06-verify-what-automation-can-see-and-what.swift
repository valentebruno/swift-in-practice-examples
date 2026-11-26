// Swift in Practice — Edition #25: Accessibility as an Architectural Constraint
// Section: Verify what automation can see, and what it cannot
// https://swiftinpractice.com/editions/25-accessibility-as-an-architectural-constraint/#verify-what-automation-can-see-and-what-it-cannot

import XCTest

final class DashboardAccessibilityTests: XCTestCase {
    @MainActor
    func testDashboardPassesAudit() throws {
        let app = XCUIApplication()
        app.launch()
        try app.performAccessibilityAudit()
    }
}
