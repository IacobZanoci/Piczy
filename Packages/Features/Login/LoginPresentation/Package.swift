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
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/CredentialsValidator"),
        .package(path: "../NetworkClient")
    ],
    targets: [
        .target(
            name: "LoginPresentation",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "UIComponents", package: "DesignSystem"),
                "CredentialsValidator", "NetworkClient"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "LoginPresentationTests",
            dependencies: [
                "LoginPresentation",
                "CredentialsValidator" ,
                "NetworkClient"
            ]
        )
    ]
)
