// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "GFGoogleDirection",
    products: [
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
