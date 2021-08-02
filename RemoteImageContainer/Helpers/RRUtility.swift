//
//  RRUtility.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 15/07/2021.
//

import Foundation

public class RRUtility: NSObject {
    
    static func getDocumentsDirectoryURL(folder: String) -> URL? {
        
        let fileManager = FileManager.default
        guard let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let directoryURL = path.appendingPathComponent(folder)
        if fileManager.fileExists(atPath: directoryURL.path) == false {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                RRLogger.log(type: RemoteImageContainer.self, message: "Could not create directory into Documents Directory", additionalInfo: error.localizedDescription)
                return nil
            }
        }
        return directoryURL
        
    }
    
    static func checkFileInCache(url: URL, type: RRFileType, completion: FileExistsCompletion) {
        
        let fileDirectoryURL = getDocumentsDirectoryURL(folder: type.rawValue)
        if let fileURL = fileDirectoryURL?.appendingPathComponent(url.getFileNameFromURL()) {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                completion(fileURL)
            } else {
                completion(nil)
            }
        }

    }
    
}
