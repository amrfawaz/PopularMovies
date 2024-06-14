// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Packages",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AppConfigurations",
            targets: ["AppConfigurations"]),
        .library(
            name: "PopularMoviesList",
            targets: ["PopularMoviesList"]),
        .library(
            name: "CoreInterface",
            targets: ["CoreInterface"]),
        .library(
            name: "Networking",
            targets: ["Networking"])
    ],
    targets: [
        .target(
            name: "AppConfigurations",
            dependencies: []),
        .target(
            name: "PopularMoviesList",
            dependencies: [
                "CoreInterface",
                "AppConfigurations",
                "Networking"
            ]),
        .target(
            name: "CoreInterface",
            dependencies: []),
        .target(
            name: "Networking",
            dependencies: []),
    ]
)
