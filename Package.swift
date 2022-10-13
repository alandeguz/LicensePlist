// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "LicensePlist",
    platforms: [
      .iOS(.v13),
      .watchOS(.v6),
      .macOS(.v10_15),
      .tvOS(.v13)
    ],
    products: [
        .plugin(name: "LicensePlistPlugin", targets: ["LicensePlistPlugin"]),
    ],
    dependencies: [],
    targets: [
        .plugin(
          name: "LicensePlistPlugin",
          capability: .command(
            intent: .custom(
              verb: "generate-code-for-resources",
              description: "Creates type-safe for all your resources"
            ),
            permissions: [
              .writeToPackageDirectory(reason: "This command generates source code")
            ]
          ),
          dependencies: ["LicensePlistBinary"]),
        .binaryTarget(
          name: "LicensePlistBinary",
          url: "https://github.com/alandeguz/swift-build-tools/releases/download/1.0.4/LicensePlistBinary-macos.artifactbundle.zip",
          checksum: "f2619e91a34b38a525b65d307f7828df6094628ae113c2ab7173eb995c456bb1"
        )
    ]
)
