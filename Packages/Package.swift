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
            targets: ["Networking"]),
        .library(
            name: "MovieDetails",
            targets: ["MovieDetails"])
    ],
    targets: [
        .target(
            name: "AppConfigurations",
            dependencies: []),
        .target(
            name: "CoreInterface",
            dependencies: []),
        .target(
            name: "Networking",
            dependencies: []),
        .target(
            name: "PopularMoviesList",
            dependencies: [
                "CoreInterface",
                "AppConfigurations",
                "Networking",
                "MovieDetails"
            ]),
        .target(
            name: "MovieDetails",
            dependencies: [
                "CoreInterface",
                "AppConfigurations",
                "Networking"
            ]),
        .testTarget(
            name: "MovieDetailsTests",
            dependencies: ["MovieDetails"],
            path: "Tests/MovieDetailsTests",
            sources: ["MovieDetailsViewModelTests.swift"]
        ),
        .testTarget(
            name: "PopularMoviesListTests",
            dependencies: ["PopularMoviesList"],
            path: "Tests/PopularMoviesListTests",
            sources: ["PopularMoviesViewModelTests.swift"]
        )
    ]
)
