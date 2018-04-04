// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "GitHub",
    products: [
        .library(name: "GitHub", targets: ["GitHub"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-stack/http.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/async.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/test.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/fiber.git",
            .branch("master")),
    ],
    targets: [
        .target(name: "GitHub", dependencies: ["HTTP", "Async"]),
        .testTarget(
            name: "GitHubTests",
            dependencies: ["GitHub", "Fiber", "Test"])
    ]
)
