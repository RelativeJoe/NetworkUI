// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "NetworkUI",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6)
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
