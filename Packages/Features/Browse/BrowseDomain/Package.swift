// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BrowseDomain",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "BrowseDomain",
            targets: ["BrowseDomain"]),
    ],
    targets: [
        .target(
            name: "BrowseDomain"),
        .testTarget(
            name: "BrowseDomainTests",
            dependencies: ["BrowseDomain"]
        ),
    ]
)
