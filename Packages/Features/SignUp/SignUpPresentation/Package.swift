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
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/CredentialsValidator"),
        .package(path: "../NetworkClient"),
        .package(path: "../SignUpDomain")
    ],
    targets: [
        .target(
            name: "SignUpPresentation",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "UIComponents", package: "DesignSystem"),
                .product(name: "CredentialsValidator", package: "CredentialsValidator"),
                .product(name: "NetworkClient", package: "NetworkClient")
            ]
        ),
        .testTarget(
            name: "SignUpPresentationTests",
            dependencies: [
                "SignUpPresentation",
                "SignUpDomain",
                "CredentialsValidator",
                "NetworkClient"
            ]
        )
    ]
)
