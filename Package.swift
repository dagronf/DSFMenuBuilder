// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "DSFMenuBuilder",
	platforms: [
		.macOS(.v10_11),
	],
	products: [
		.library(
			name: "DSFMenuBuilder",
			type: .static,
			targets: ["DSFMenuBuilder"]
		),
		.library(
			name: "DSFMenuBuilderDynamic",
			type: .dynamic,
			targets: ["DSFMenuBuilder"]
		),
	],
	dependencies: [
	],
	targets: [
		.target(
			name: "DSFMenuBuilder",
			dependencies: []
		),
		.testTarget(
			name: "DSFMenuBuilderTests",
			dependencies: ["DSFMenuBuilder"]
		),
	]
)
