// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClipMelodyKit",
    products: [
        .library(name: "ClipMelodyKit", targets: ["ClipMelodyKit"]),
    ],
    targets: [
        .target(name: "ClipMelodyKit"),
        .testTarget(name: "ClipMelodyKitTests", dependencies: ["ClipMelodyKit"]),
    ]
)
