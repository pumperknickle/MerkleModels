// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MerkleModels",
    products: [
        .library(
            name: "MerkleModels",
            targets: ["MerkleModels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-postgresql", from: "1.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.1"),
        .package(url: "https://github.com/pumperknickle/Bedrock.git", from: "0.0.6"),
        .package(url: "https://github.com/pumperknickle/CryptoStarterPack.git", from: "1.1.1"),
        .package(url: "https://github.com/pumperknickle/AwesomeDictionary.git", from: "0.0.3"),
		.package(url: "https://github.com/Quick/Quick.git", from: "2.1.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.2"),
    ],
    targets: [
        .target(
            name: "MerkleModels",
            dependencies: ["CryptoStarterPack", "AwesomeDictionary", "Bedrock", "Vapor", "FluentPostgreSQL"]),
        .testTarget(
            name: "MerkleModelsTests",
            dependencies: ["MerkleModels", "Quick", "Nimble", "CryptoStarterPack", "Bedrock"]),
    ]
)
