// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BrowsePresentation",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "BrowsePresentation",
            targets: ["BrowsePresentation"]
        )
    ],
    dependencies: [
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Features/Login/LoginPresentation"),
        .package(path: "../BrowseDomain")
    ],
    targets: [
        .target(
            name: "BrowsePresentation",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "UIComponents", package: "DesignSystem"),
                .product(name: "LoginPresentation", package: "LoginPresentation"),
                .product(name: "BrowseDomain", package: "BrowseDomain")
            ]
        ),
        .testTarget(
            name: "BrowsePresentationTests",
            dependencies: ["BrowsePresentation"]
        ),
    ]
)
