// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwiftSignatureView",
    platforms: [.iOS(.v13),
                .tvOS(.v13),
                .visionOS(.v1)],
    products: [
        .library(name: "SwiftSignatureView", targets: ["SwiftSignatureView"])
    ],
    targets: [
        .target(name: "SwiftSignatureView", path: "Pod"),
        .testTarget(name: "SwiftSignatureViewTest", dependencies: ["SwiftSignatureView"], path: "Example/Tests")
    ]
)
