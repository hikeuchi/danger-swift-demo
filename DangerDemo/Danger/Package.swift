// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Dangerfile",
    platforms: [.macOS("10.12")],
    products: [
        .library(name: "DangerDepsProduct",
                 type: .dynamic,
                 targets: ["DangerDependencies"]),
    ],
    dependencies: [
        // Danger
        .package(name: "danger-swift", url: "https://github.com/danger/swift.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "DangerDependencies",
            dependencies: [
                .product(name: "Danger", package: "danger-swift"),
            ]
        ),
    ]
)
