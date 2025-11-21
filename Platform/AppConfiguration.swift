//
//  AppConfiguration.swift
//  Platform
//
//  Created by Đào Đăng Sơn on 21/11/25.
//

import Foundation

public enum BuildConfiguration {
    case debug
    case release
    case mock
}

public struct AppConfiguration {
    public static let shared = AppConfiguration()

    public var buildConfiguration: BuildConfiguration {
        let isUITestMode = CommandLine.arguments.contains("UITestMode")
        if isUITestMode {
            return .mock
        } else {
#if MOCK
            return .mock
#elseif DEBUG
            return .debug
#else
            return .release
#endif
        }
    }
}
