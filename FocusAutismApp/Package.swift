// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "FocusAutismApp",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "FocusAutismApp", targets: ["FocusAutismApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "FocusAutismApp",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Collections", package: "swift-collections")
            ]
        )
    ]
)