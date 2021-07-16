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
    
    static func checkImageInCache(url: URL, completion: (_ isImageExists: Bool?, _ imageURL: URL?, _ error: RRError?) -> Void) {
        
        let imagesDirectoryURL = getDocumentsDirectoryURL(folder: "Images")
        if let imageFileURL = imagesDirectoryURL?.appendingPathComponent(url.getFileNameFromURL()) {
            if FileManager.default.fileExists(atPath: imageFileURL.path) {
                completion(true, imageFileURL, nil)
            } else {
                completion(false, nil, nil)
            }
        } else {
            completion(nil, nil, RRError(location: RRUtility.self, message: .anyError))
        }

    }
    
}
