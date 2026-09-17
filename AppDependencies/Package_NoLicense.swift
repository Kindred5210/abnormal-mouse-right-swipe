// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AppDependencies",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "AppDependencies",
            targets: ["AppDependencies"]
        ),
    ],
    dependencies: [
        .package(
            name: "CGEventOverride",
            url: "https://github.com/intitni/CGEventOverride.git",
            .revision("a6585d580eedc151ec9918af06a182d26e1248f5")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .exact("0.28.1")
        ),
        .package(
            url: "https://github.com/CombineCommunity/CombineExt",
            .exact("1.5.1")
        ),
    ],
    targets: [
        .target(
            name: "AppDependencies",
            dependencies: [
                "CGEventOverride",
                "CombineExt",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
    ]
)
