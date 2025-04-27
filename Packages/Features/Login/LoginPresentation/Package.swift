// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LoginPresentation",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "LoginPresentation",
            targets: ["LoginPresentation"]
        )
    ],
    dependencies: [
        .package(path: "../../Core/DesignSystem")
    ],
    targets: [
        .target(
            name: "LoginPresentation",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "UIComponents", package: "DesignSystem")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "LoginPresentationTests",
            dependencies: ["LoginPresentation"]
        ),
    ]
)
