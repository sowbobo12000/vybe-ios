// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "vybe",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "vybe",
            targets: ["vybe"]
        )
    ],
    targets: [
        .target(
            name: "vybe",
            path: "vybe",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "vybeTests",
            dependencies: ["vybe"],
            path: "vybeTests"
        )
    ]
)
