// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aoc-2022-swift",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.0")
    ],
    targets: [
        .executableTarget(
            name: "aoc-2022-swift",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources",
            resources: [
                .copy("Resources")
            ]
        ),
        .testTarget(
            name: "aoc-2022-swiftTests",
            dependencies: ["aoc-2022-swift"],
            path: "Tests"
        ),
    ]
)
