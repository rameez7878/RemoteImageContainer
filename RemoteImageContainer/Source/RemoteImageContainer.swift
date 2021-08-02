//
//  RemoteImageContainer.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 15/07/2021.
//

import UIKit

public class RemoteImageContainer: UIView {
    
    
    // MARK:- Properties
    private var imageView: UIImageView = UIImageView()
    public var image: UIImage? {
        imageView.image
    }
    private var url: URL?
    private var overLay: UIView?
    
    
    // MARK:- Initializers
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    // MARK:- Custom Methods
    private func setup() {
        
        clipsToBounds = true
        backgroundColor = .clear
        setupImageView()
        _ = RRDownloadManager.shared().addObserver(observer: self)
        
    }
    
    private func setupImageView() {

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        insertSubview(imageView, at: 0)
        
        addEdgeToEdgeConstraints(to: imageView)
        
    }
    
    public func setImage(url: URL, overLay: Bool = false, overLayWithOpacity: CGFloat = 0.4) {
        
        self.url = url
        refreshImageView()
        if overLay {
            addOverLay(opacity: overLayWithOpacity)
        }
        
    }
        
    private func refreshImageView() {

        showActivityIndicator()
        guard let url = url else {
            return
        }
        
        RRDownloadManager.shared().fileExists(for: url, type: .image) { localFileURL in
            
            if let localFileURL = localFileURL {
                
                self.hideActivityIndicator()
                self.imageView.image = UIImage(contentsOfFile: localFileURL.path)

            } else {
                
                self.showActivityIndicator()
                RRDownloadManager.shared().download(url: url, type: .image) { error in
                    if let error = error {
                        RRLogger.log(type: RemoteImageContainer.self, message: error.message)
                    }
                }
                
            }
            
        }

    }
    
    private func addEdgeToEdgeConstraints(to view: UIView) {
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.heightAnchor.constraint(equalTo: heightAnchor)
        ])

    }
    
    private func addOverLay(opacity: CGFloat) {
                
        if overLay == nil {
            
            overLay = UIView()
            overLay?.translatesAutoresizingMaskIntoConstraints = false
            overLay?.backgroundColor = .black
            overLay?.alpha = opacity
            insertSubview(overLay!, at: 1)
            
            addEdgeToEdgeConstraints(to: overLay!)
            
        }
        
    }
    
    private func showActivityIndicator() {
        imageView.isHidden = true
        addShimmer()
    }
    
    private func hideActivityIndicator() {
        imageView.isHidden = false
        removeShimmer()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if imageView.isHidden {
            removeShimmer()
            addShimmer()
        }
    }
    
}


// MARK:- RRDownloadManagerObserver
extension RemoteImageContainer: RRDownloadManagerObserver {
    
    public func rrDownloadManager(didStartDownloadingFor url: URL) {
        if url == self.url {
            RRLogger.log(type: RemoteImageContainer.self, message: "Downloading started for URL: `\(url.absoluteString)`")
        }
    }
    
    public func rrDownloadManager(didWriteDataWith progress: Float, for url: URL) {
        if url == self.url {
            RRLogger.log(type: RemoteImageContainer.self, message: "Downloading progress: '\(progress * 100)%' for URL: `\(url.absoluteString)`")
        }
    }
    
    public func rrDownloadManager(didFinishDownloadingFor url: URL, to location: URL) {
        if url == self.url {
            refreshImageView()
            RRLogger.log(type: RemoteImageContainer.self, message: "Downloading finished for URL: `\(url.absoluteString)`")
        }
    }
    
    public func rrDownloadManager(didFinishDownloadingFor url: URL, with error: RRError) {
        if url == self.url {
            RRLogger.log(type: RemoteImageContainer.self, message: "Downloading finished with error: `\(error.message)` for URL: \(url.absoluteString)")
        }
    }
        
}
