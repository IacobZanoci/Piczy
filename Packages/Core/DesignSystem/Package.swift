// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]
        )
    ],
    targets: [
        .target(name: "DesignSystem"),
        .target(
            name: "UIComponents",
            dependencies: [
                .byName(name: "DesignSystem")
            ]
        )
    ]
)
