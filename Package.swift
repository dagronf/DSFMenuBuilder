// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "DSFMenuBuilder",
	platforms: [
		.macOS(.v10_11),
	],
	products: [
		.library(name: "DSFMenuBuilder", targets: ["DSFMenuBuilder"]),
		.library(name: "DSFMenuBuilder-static", type: .static, targets: ["DSFMenuBuilder"]),
		.library(name: "DSFMenuBuilder-shared", type: .dynamic, targets: ["DSFMenuBuilder"]),
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
