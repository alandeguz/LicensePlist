// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "LicensePlist",
    products: [
        .plugin(name: "LicensePlistBuildTool", targets: ["LicensePlistBuildTool"]),
        .plugin(name: "GenerateAcknowledgementsCommand", targets: ["GenerateAcknowledgementsCommand"]),
        .plugin(name: "AddAcknowledgementsCopyScriptCommand", targets: ["AddAcknowledgementsCopyScriptCommand"]),
    ],
    dependencies: [],
    targets: [
        .plugin(
            name: "LicensePlistBuildTool",
            capability: .buildTool(),
            dependencies: ["LicensePlistBinary"]
        ),
        .plugin(
            name: "GenerateAcknowledgementsCommand",
            capability: .command(
                intent: .custom(
                    verb: "license-plist",
                    description: "LicensePlist generates acknowledgements"
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "LicensePlist generates acknowledgements inside the project directory")
                ]
            ),
            dependencies: ["LicensePlistBinary"]
        ),
        .plugin(
            name: "AddAcknowledgementsCopyScriptCommand",
            capability: .command(
                intent: .custom(
                    verb: "license-plist-add-copy-script",
                    description: "LicensePlist adds a copy script to build phases"
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "LicensePlist updates project file")
                ]
            ),
            dependencies: ["LicensePlistBinary"]
        ),
        .binaryTarget(
            name: "LicensePlistBinary",
            url: "https://github.com/mono0926/LicensePlist/releases/download/3.27.1/LicensePlistBinary-macos.artifactbundle.zip",
            checksum: "24e066b23da58275a89a83cae05bf40cad8a48faacf10facbfa5c350efe02608"
        )
    ]
)
