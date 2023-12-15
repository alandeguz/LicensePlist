// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "LicensePlist",
    products: [
        .plugin(name: "LicensePlistBuildTool", targets: ["LicensePlistBuildTool"]),
        .plugin(name: "GenerateAcknowledgementsCommand", targets: ["GenerateAcknowledgementsCommand"]),
        .plugin(name: "AddAcknowledgementsCopyScriptCommand", targets: ["AddAcknowledgementsCopyScriptCommand"])
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
            url: "https://github.com/mono0926/LicensePlist/releases/download/3.25.1/LicensePlistBinary-macos.artifactbundle.zip",
            checksum: "a80181eeed49396dae5d3ce6fc339f33a510299b068fd6b4f507483db78f7f30"
        )
    ]
)
