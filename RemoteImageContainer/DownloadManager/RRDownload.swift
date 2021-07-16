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
    public var task: URLSessionDownloadTask?

    
    // MARK:- Initializers
    public init(url: URL) {
        fromFileURL = url
        toFileURL = RRUtility.getDocumentsDirectoryURL(folder: "Images")?.appendingPathComponent(fromFileURL.getFileNameFromURL())
    }
    
}
