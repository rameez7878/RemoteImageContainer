//
//  RRDownload.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 15/07/2021.
//

import Foundation

public class RRDownload {

    
    // MARK:- Properties
    public let fromFileURL: URL
    public let toFileURL: URL?
    public let type: RRFileType
    public var task: URLSessionDownloadTask?

    
    // MARK:- Initializers
    public init(url: URL, type: RRFileType) {
        self.type = type
        self.fromFileURL = url
        self.toFileURL = RRUtility.getDocumentsDirectoryURL(folder: self.type.rawValue)?.appendingPathComponent(fromFileURL.getFileNameFromURL())
    }
        
}


public enum RRFileType: String {
    case image = "Images"
    case audio = "Audios"
    case video = "Videos"
    case file = "Files"
}
