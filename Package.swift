// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GFGoogleDirection",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GFGoogleDirection",
            targets: ["GFGoogleDirection"]),
    ],
    dependencies: [
       .package(url: "https://github.com/vapor/vapor.git", from: "3.0.8"),
    ],
    targets: [
        .target(
            name: "GFGoogleDirection",
            dependencies: ["Vapor"]),
        .testTarget(
            name: "GFGoogleDirectionTests",
            dependencies: ["GFGoogleDirection"]),
    ]
)
