// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "NexSignServer",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "Run", targets: ["App"]) 
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ],
            path: "Sources/App"
        )
    ]
)
