//
//  LicensePlistBuildToolPlugin.swift
//  Plugins/LicensePlist
//
//  Created by Alan DeGuzman on 9/23/22.
//

import Foundation
import PackagePlugin

@main

// for operating on a Swift package
struct LicensePlistBuildToolPlugin: BuildToolPlugin {

  // disabled as plugin intended only for Xcode projects
  func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
    return [
      .buildCommand(
        displayName: "\(Const.skipFor) \(target.name)",
        executable: Const.doNothing,
        arguments: [],
        environment: [:]
      )
    ]
  }

}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

// for operating on an Xcode project
extension LicensePlistBuildToolPlugin: XcodeBuildToolPlugin {

  func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
    let configPath = context.xcodeProject.directory.appending(subpath: ".license-plist-config.plist")
    let config = try Config.parseConfig(configPath.string)
    if let env = ProcessInfo.processInfo.environment[config.ciEnvironment], !env.isEmpty {
      return [
        .buildCommand(
          displayName: "\(Const.skipFor) \(target.displayName)",
          executable: Const.doNothing,
          arguments: [],
          environment: [:]
        )
      ]
    }

    // only execute on non-CI builds
    return [
      try licenseplist(context: context, target: target)
    ]
  }

  func licenseplist(context: XcodePluginContext, target: XcodeTarget) throws -> Command {
    let configPath = context.xcodeProject.directory.appending(subpath: ".license-plist-config.plist")
    let config = try Config.parseConfig(configPath.string)
    
    let xcodeProjectPath = context.xcodeProject.directory.appending(subpath: config.xcodeProjectName)
    let outputPath = context.xcodeProject.directory.appending(subpath: config.output)
    
    var arguments = [
      "--suppress-opening-directory",
      "--xcodeproj-path", xcodeProjectPath.string,
      "--output-path", outputPath.string,
    ]
    
    if !config.prefix.isEmpty {
      arguments.append("--prefix")
      arguments.append(config.prefix)
    }
    
    if config.addVersionNumbers {
      arguments.append("--add-version-numbers")
    }
    return
      .prebuildCommand(
        displayName: "Running LicensePlist",
        executable: try context.tool(named: "license-plist").path,
        arguments: arguments,
        environment: [: ],
        outputFilesDirectory: context.pluginWorkDirectory
      )
  }

}

struct Config: Codable {
  let xcodeProjectName: String
  let output: String
  let prefix: String
  let addVersionNumbers: Bool
  let ciEnvironment: String
  
  static func parseConfig(_ path: String) throws -> Config  {
    guard let file = FileManager.default.contents(atPath: path) else {
      throw URLError(URLError.Code(rawValue: NSURLErrorFileDoesNotExist))
    }
    return try PropertyListDecoder().decode(Config.self, from: file)
  }
}

#endif

enum Const {
  static let doNothing = PackagePlugin.Path("/usr/bin/true")
  static let skipFor = "Skipping LicensePlist for"
}
