// Swift in Practice — Edition #34: Swift 6.4.2: What Compiler Fixes Reveal About Production Reliability
// Section: Record the complete build identity
// https://swiftinpractice.com/editions/34-swift-6-4-2-production-reliability/#record-the-complete-build-identity

import Foundation

struct BuildIdentity: Equatable, Sendable {
    let xcodeBuild: String
    let sdkBuild: String
    let appBuild: String

    init(bundle: Bundle = .main) {
        let info = bundle.infoDictionary ?? [:]
        xcodeBuild = info["DTXcodeBuild"] as? String ?? "unknown"
        sdkBuild = info["DTSDKBuild"] as? String ?? "unknown"
        appBuild = info["CFBundleVersion"] as? String ?? "unknown"
    }
}
