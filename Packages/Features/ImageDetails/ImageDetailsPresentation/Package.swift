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
        .package(path: "../../Core/DesignSystem")
    ],
    targets: [
        .target(
            name: "ImageDetailsPresentation",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "UIComponents", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "ImageDetailsPresentationTests",
            dependencies: ["ImageDetailsPresentation"]
        )
    ]
)
