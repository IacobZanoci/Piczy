// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LoginDomain",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "LoginDomain",
            targets: ["LoginDomain"]),
    ],
    dependencies: [
        .package(path: "../../Core/CredentialsValidator"),
        .package(path: "../../NetworkClient"),
        .package(path: "../LoginPresentation")
    ],
    targets: [
        .target(
            name: "LoginDomain",
            dependencies: [
                "CredentialsValidator",
                "NetworkClient"
            ]
        ),
        .testTarget(
            name: "LoginDomainTests",
            dependencies: [
                "LoginDomain",
                "LoginPresentation",
                "CredentialsValidator" ,
                "NetworkClient"
            ]
        )
    ]
)
