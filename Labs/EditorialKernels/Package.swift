// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "EditorialKernels",
    products: [.library(name: "EditorialKernels", targets: ["EditorialKernels"])],
    targets: [
        .target(name: "EditorialKernels"),
        .testTarget(name: "EditorialKernelsTests", dependencies: ["EditorialKernels"])
    ]
)
