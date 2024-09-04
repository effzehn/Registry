// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Registry",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Registry",
            targets: ["Registry"]),
    ],
    targets: [
        .target(
            name: "Registry",
            dependencies: []),
        .testTarget(
            name: "RegistryTests",
            dependencies: ["Registry"]),
    ]
)
