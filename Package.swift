// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkUI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "NetworkUI", targets: ["NetworkUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "NetworkUI", dependencies: []),
    ]
)
