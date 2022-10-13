// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "LicensePlist",
  products: [
    .executable(name: "license-plist", targets: ["LicensePlist"]),
    .library(name: "LicensePlistCore", targets: ["LicensePlistCore"]),
    .plugin(name: "LicensePlistPlugin", targets: ["LicensePlistPlugin"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git",
             from: "1.1.4"),
    .package(url: "https://github.com/ishkawa/APIKit.git",
             from: "5.3.0"),
    .package(url: "https://github.com/Kitura/HeliumLogger.git",
             from: "2.0.0"),
    .package(url: "https://github.com/behrang/YamlSwift.git",
             from: "3.4.4"),
    .package(url: "https://github.com/Kitura/swift-html-entities.git",
             from: "4.0.1"),
    .package(url: "https://github.com/YusukeHosonuma/SwiftParamTest",
             .upToNextMajor(from: "2.0.0")),
  ],
  targets: [
    .target(
      name: "LicensePlist",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "LicensePlistCore",
        "HeliumLogger",
      ]
    ),
    .target(
      name: "LicensePlistCore",
      dependencies: [
        "APIKit",
        "HeliumLogger",
        .product(name: "HTMLEntities", package: "swift-html-entities"),
        .product(name: "Yaml", package: "YamlSwift")
      ]
    ),
    .plugin(
      name: "LicensePlistPlugin",
      capability: .buildTool(),
      dependencies: ["LicensePlistBinary"]),
    .binaryTarget(
      name: "LicensePlistBinary",
      url: "https://github.com/alandeguz/swift-build-tools/releases/download/1.0.4/LicensePlistBinary-macos.artifactbundle.zip",
      checksum: "f2619e91a34b38a525b65d307f7828df6094628ae113c2ab7173eb995c456bb1"
    ),
    .testTarget(
      name: "LicensePlistTests",
      dependencies: ["LicensePlistCore", "SwiftParamTest"],
      exclude: [
        "Resources",
        "XcodeProjects",
      ]
    ),
  ]
)
