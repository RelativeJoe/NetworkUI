// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AidieNetwork",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "AidieNetwork",
            targets: ["AidieNetwork"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AidieNetwork",
            dependencies: []),
    ]
)
