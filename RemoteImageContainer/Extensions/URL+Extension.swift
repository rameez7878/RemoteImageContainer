//
//  URL+Extension.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 15/07/2021.
//

import Foundation

extension URL {
    
    func getFileNameFromURL() -> String {
        
        let urlString = absoluteString
        guard let fileName = urlString.components(separatedBy: "/").last else {
            return ""
        }
        return fileName
        
    }
    
}
