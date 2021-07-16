//
//  RRDownloadManagerObserverClient.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 15/07/2021.
//

import Foundation

public struct RRDownloadManagerObserverClient {
    
    var id: Int = 0
    weak var observer: RRDownloadManagerObserver?
    
    init(observer: RRDownloadManagerObserver) {
        self.observer = observer
    }
    
}

public protocol RRDownloadManagerObserver: AnyObject {
    func didFinishedDownload(url: URL)
}
