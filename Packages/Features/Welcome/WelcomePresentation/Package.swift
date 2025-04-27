// swift-tools-version: 6.0
 
 import PackageDescription
 
 let package = Package(
     name: "WelcomePresentation",
     platforms: [.iOS(.v17)],
     products: [
         .library(
             name: "WelcomePresentation",
             targets: ["WelcomePresentation"]
         )
     ],
     dependencies: [
         .package(path: "../../Core/DesignSystem")
     ],
     targets: [
         .target(
             name: "WelcomePresentation",
             dependencies: [
                 .product(name: "DesignSystem", package: "DesignSystem"),
                 .product(name: "UIComponents", package: "DesignSystem")
             ]
         )
     ]
 )
