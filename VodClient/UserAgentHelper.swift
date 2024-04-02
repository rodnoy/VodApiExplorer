//
//  UserAgentHelper.swift
//  VodClient
//
//  Created by KIRILL SIMAGIN on 03/04/2024.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if canImport(Cocoa)
import Cocoa
#endif
public struct UserAgentHelper {
    public static var userAgent: String {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "App"
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
#if os(iOS)
        let deviceModel = UIDevice.current.model
        let osName = UIDevice.current.systemName
        let osVersion = "\(osName) \(UIDevice.current.systemVersion)"
        let screenScale = UIScreen.main.scale
        let details = "\(deviceModel); \(osVersion); Scale/\(screenScale)"
#elseif os(macOS)
        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        let details = "macOS \(osVersion)"
#elseif os(visionOS)
        let deviceModel = UIDevice.current.model
        let osName = UIDevice.current.systemName
        let osVersion = "\(osName) \(UIDevice.current.systemVersion)"
        let screenScale = UIScreen.main.scale
        let details = "\(deviceModel); \(osVersion); Scale/\(screenScale)"
#else
        let details = "Unknown Platform"
#endif
        return "\(appName)/\(appVersion) (\(details))"
    }
}
