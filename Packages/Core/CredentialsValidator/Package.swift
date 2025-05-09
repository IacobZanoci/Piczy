// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CredentialsValidator",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CredentialsValidator",
            targets: ["CredentialsValidator"]),
    ],
    targets: [
        .target(
            name: "CredentialsValidator",
            dependencies: []
        ),
        .testTarget(
            name: "CredentialsValidatorTests",
            dependencies: ["CredentialsValidator"]
        )
    ]
)
