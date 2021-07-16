//
//  RRLogger.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 15/07/2021.
//

import Foundation

struct RRLogger {
    
    static func log(type: NSObject.Type, message: String, additionalInfo: String? = nil) {
        
        var areLogsEnabled: Bool = false
        if let logs = ProcessInfo.processInfo.environment["RR_LOGS"], logs == "enable" {
            areLogsEnabled = true
        }

        if areLogsEnabled {

            if additionalInfo == nil {
                print("[\(type)]: \(message)")
            } else {
                print("[\(type)]: \(message): \(additionalInfo!)")
            }

        }
        
    }
    
}
