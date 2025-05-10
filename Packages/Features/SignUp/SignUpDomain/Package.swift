// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SignUpDomain",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "SignUpDomain",
            targets: ["SignUpDomain"]),
    ],
    dependencies: [
        .package(path: "../../Core/CredentialsValidator"),
        .package(path: "../../NetworkClient"),
        .package(path: "../SignUpPresentation")
    ],
    targets: [
        .target(
            name: "SignUpDomain",
            dependencies: [
                "CredentialsValidator",
                "NetworkClient"
            ]
        ),
        .testTarget(
            name: "SignUpDomainTests",
            dependencies: [
                "SignUpDomain",
                "SignUpPresentation",
                "CredentialsValidator" ,
                "NetworkClient"
            ]
        )
    ]
)
