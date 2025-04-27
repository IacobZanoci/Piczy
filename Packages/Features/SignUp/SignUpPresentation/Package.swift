// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SignUpPresentation",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "SignUpPresentation",
            targets: ["SignUpPresentation"]
        ),
    ],
    dependencies: [
        .package(path: "../../Core/DesignSystem")
    ],
    targets: [
        .target(
            name: "SignUpPresentation",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "UIComponents", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "SignUpPresentationTests",
            dependencies: ["SignUpPresentation"]
        ),
    ]
)
