// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ImageDetailsDomain",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "ImageDetailsDomain",
            targets: ["ImageDetailsDomain"]
        ),
    ],
    dependencies: [
        .package(path: "../../Core/NetworkClient")
    ],
    targets: [
        .target(
            name: "ImageDetailsDomain",
            dependencies: [
                .product(name: "NetworkClient", package: "NetworkClient")
            ]
        ),
        .testTarget(
            name: "ImageDetailsDomainTests",
            dependencies: [
                "ImageDetailsDomain",
                "NetworkClient"
            ]
        ),
    ]
)
