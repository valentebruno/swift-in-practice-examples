// Swift in Practice — Edition #24: Should the Music Stop When Analytics Fails?
// Section: How a telemetry call gets authority over playback
// https://swiftinpractice.com/editions/24-playback-and-analytics-failure-boundaries/#how-a-telemetry-call-gets-authority-over-playback

import Foundation

struct LegacyServices {
    var checkEntitlement: @Sendable (String) async throws -> Void
    var prepareMedia: @Sendable (String) async throws -> Void
    var reportStarted: @Sendable (String) async throws -> Void
}

func legacyPlay(trackID: String, services: LegacyServices) async throws {
    async let entitlement: Void = services.checkEntitlement(trackID)
    async let media: Void = services.prepareMedia(trackID)
    async let report: Void = services.reportStarted(trackID)

    _ = try await (entitlement, media, report)
}
