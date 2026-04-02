// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PlanetaryEphemeris",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "PlanetaryEphemeris",
            targets: ["PlanetaryEphemeris"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/vsmithers1087/SwissEphemeris.git", from: "0.0.99")
    ],
    targets: [
        .executableTarget(
            name: "PlanetaryEphemeris",
            dependencies: [
                "PlanetaryEphemeris",
                .product(name: "SwissEphemeris", package: "SwissEphemeris")
            ],
            path: "Sources/PlanetaryEphemeris"
        )
    ]
)
