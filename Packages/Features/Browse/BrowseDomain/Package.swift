// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BrowseDomain",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "BrowseDomain",
            targets: ["BrowseDomain"]
        ),
    ],
    dependencies: [
        .package(path: "../../Core/NetworkClient")
    ],
    targets: [
        .target(
            name: "BrowseDomain",
            dependencies: [
                .product(name: "NetworkClient", package: "NetworkClient")
            ]
        ),
        .testTarget(
            name: "BrowseDomainTests",
            dependencies: ["BrowseDomain"]
        ),
    ]
)
