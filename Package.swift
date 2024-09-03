// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Registry",
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
