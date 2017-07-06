// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "HelloFluent",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura", majorVersion: 1, minor: 7),
    	.Package(url: "https://github.com/vapor/fluent", majorVersion: 2),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/vapor-community/postgresql-driver.git", majorVersion: 2)
    ]
)
