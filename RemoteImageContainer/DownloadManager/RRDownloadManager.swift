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
        let configuration = URLSessionConfiguration.default
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
    
    public func fileExists(for url: URL, type: RRFileType, completion: FileExistsCompletion) {
        RRUtility.checkFileInCache(url: url, type: type, completion: completion)
    }
    
    public func download(url: URL, type: RRFileType, completion: DownloadStartCompletion) {
        
        let download = RRDownload(url: url, type: type)
        
        if download.toFileURL == nil {
            completion(RRError(location: RRDownloadManager.self, message: .unExpectedResult))
        } else {
            
            if !activeDownloads.keys.contains(download.fromFileURL) {
                                    
                activeDownloads[download.fromFileURL] = download
                
                download.task = self.downloadsSession.downloadTask(with: url)
                download.task?.resume()

                observers.forEach { client in
                    client.observer?.rrDownloadManager(didStartDownloadingFor: url)
                }

            }
            
            completion(nil)

        }
        
    }
    
    public func cancelAllDownloads(completion: DownloadsCancelledCompletion = nil) {
        
        activeDownloads.forEach { (_, download) in
            download.task?.cancel()
        }
        activeDownloads.removeAll()
        
        completion?()

    }
    
}


// MARK:- URLSessionDelegate & URLSessionDownloadDelegate
extension RRDownloadManager: URLSessionDelegate, URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        guard let activeDownload = activeDownloads.first(where: { $0.value.fromFileURL == sourceURL }) else { return }
            
        let download = activeDownload.value
        activeDownloads.removeValue(forKey: download.fromFileURL)
        
        do {
            
            let downloadedData = try Data(contentsOf: location)
            try downloadedData.write(to: download.toFileURL!)
            
            DispatchQueue.main.async {
                self.observers.forEach { client in
                    client.observer?.rrDownloadManager(didFinishDownloadingFor: download.fromFileURL, to: download.toFileURL!)
                }
            }
            
        } catch {
            
            DispatchQueue.main.async {
                self.observers.forEach { client in
                    client.observer?.rrDownloadManager(didFinishDownloadingFor: download.fromFileURL, with: RRError(location: RRDownloadManager.self, message: "Downloaded file is courrpted \(error.localizedDescription)"))
                }
            }
            
        }
        
    }
        
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        guard let activeDownload = activeDownloads.first(where: { $0.value.fromFileURL == sourceURL }) else { return }
        
        let download = activeDownload.value
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.observers.forEach { client in
                client.observer?.rrDownloadManager(didWriteDataWith: progress, for: download.fromFileURL)
            }
        }
        
    }
    
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        RRLogger.log(type: RRDownloadManager.self, message: "Waiting for connectivity...")
    }
    
}
