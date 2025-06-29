// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ImageDetailsPresentation",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "ImageDetailsPresentation",
            targets: ["ImageDetailsPresentation"]
        )
    ],
    dependencies: [
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/NetworkClient"),
        .package(path: "../ImageDetailsDomain")
    ],
    targets: [
        .target(
            name: "ImageDetailsPresentation",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "UIComponents", package: "DesignSystem"),
                .product(name: "NetworkClient", package: "NetworkClient")
            ]
        ),
        .testTarget(
            name: "ImageDetailsPresentationTests",
            dependencies: [
                "ImageDetailsPresentation",
                "ImageDetailsDomain",
                "NetworkClient"
            ]
        )
    ]
)
