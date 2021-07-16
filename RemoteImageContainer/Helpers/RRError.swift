//
//  RRError.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 16/07/2021.
//

import Foundation

public struct RRError {
    
    
    // MARK:- Properties
    public let message: String

    
    // MARK:- Initializers
    public init(location: NSObject.Type, message: RRErrorMessage) {
        self.message = "[\(location)]: \(message.rawValue)"
    }

    public init(location: NSObject.Type, message: String) {
        self.message = "[\(location)]: \(message)"
    }
    
}

public enum RRErrorMessage: String {
    
    case unExpectedResult = "An unexpected error occurred while fetching data. Please try again later. If issue stil exists after several attempts then please contact support team."
    case noInternet = "There is a problem with your internet connection."
    case unableToSetupObserver = "Unable to setup some observers. Please contact support team."
    case anyError = "An unexpected error occurred. Please contact support team."

}
