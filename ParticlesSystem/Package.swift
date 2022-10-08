// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ParticlesSystem",
    platforms: [.iOS(.v13), .macOS(.v11)],
    products: [
        .library(
            name: "ParticlesSystem",
            targets: ["ParticlesSystem"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ParticlesSystem",
            dependencies: [],
            path: "Sources/ParticlesSystem"
        ),
        .testTarget(
            name: "ParticlesSystemTests",
            dependencies: ["ParticlesSystem"]),
    ]
)
