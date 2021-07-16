//
//  RRDownloadManager.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 15/07/2021.
//

import Foundation

public class RRDownloadManager: NSObject {
    
    
    // MARK:- Shared Instance
    private static var instance = RRDownloadManager()
    

    // MARK:- Properties
    private lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    private var activeDownloads: [URL: RRDownload] = [:]
    private var observers: [RRDownloadManagerObserverClient] = []
    
    
    // MARK:- Initializers
    private override init() {}
    
    
    // MARK:- Custom Methods
    public static func shared() -> RRDownloadManager {
        instance
    }
    
    public func addObserver(observer: RRDownloadManagerObserver) -> RRDownloadManagerObserverClient {
        
        var client = RRDownloadManagerObserverClient(observer: observer)
        client.id = (observers.max { $0.id < $1.id }?.id ?? 0) + 1
        observers.append(client)
        return client
        
    }
    
    public func removeObserver(client: RRDownloadManagerObserverClient) {
        observers.removeAll(where: { $0.id == client.id })
    }
    
    public func downloadExistsFor(url: URL, completion: @escaping (_ isImageExists: Bool?, _ imageURL: URL?, _ error: RRError?) -> Void) {
        
        RRUtility.checkImageInCache(url: url) { (isImageExists, imageURL, error) in
            completion(isImageExists, imageURL, error)
        }

    }
    
    public func addDownloadOperation(url: URL, completion: @escaping (_ error: RRError?) -> Void) {
        
        let download = RRDownload(url: url)
        
        if activeDownloads.keys.contains(download.fromFileURL) {
            completion(nil)
            return
        } else {
            activeDownloads[download.fromFileURL] = download
        }
        
        RRLogger.log(type: RRDownloadManager.self, message: "Image Downloading Started", additionalInfo: download.fromFileURL.absoluteString)
        
        download.task = downloadsSession.downloadTask(with: download.fromFileURL)
        download.task?.resume()

    }
            
    public func cancelAllDownloads(completion: @escaping (_ error: RRError?) -> Void) {
        
        if activeDownloads.count > 0 {
            
            activeDownloads.forEach { (url, download) in
                download.task?.cancel()
            }
            activeDownloads.removeAll()
            
            completion(nil)
            
        } else {
            completion(nil)
        }

    }
        
    private func saveImageIntoDocumentsDirectory(data: Data?, download: RRDownload) {
        
        guard let data = data else {
            return
        }
            
        do {
            
            RRLogger.log(type: RRDownloadManager.self, message: "Image Downloading Finished", additionalInfo: download.fromFileURL.absoluteString)
            try data.write(to: download.toFileURL!)
            
            DispatchQueue.main.async {
                self.observers.forEach { (client) in
                    client.observer?.didFinishedDownload(url: download.fromFileURL)
                }
            }

        } catch {
            RRLogger.log(type: RRDownloadManager.self, message: "Could not save image", additionalInfo: error.localizedDescription)
        }
        
    }
    
}


// MARK:- URLSessionDelegate & URLSessionDownloadDelegate
extension RRDownloadManager: URLSessionDelegate, URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        
        if let activeDownload = activeDownloads.first(where: { $0.value.fromFileURL == sourceURL }) {
            
            activeDownloads.removeValue(forKey: activeDownload.key)
            
            var downloadedData: Data?
            
            do {
                try downloadedData = Data(contentsOf: location)
            } catch {
                RRLogger.log(type: RRDownloadManager.self, message: "Downloaded image is courrpted", additionalInfo: error.localizedDescription)
                return
            }
            
            let download = activeDownload.value
            saveImageIntoDocumentsDirectory(data: downloadedData, download: download)

        }
        
    }
        
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        RRLogger.log(type: RRDownloadManager.self, message: "Waiting for connectivity...")
    }
    
}
