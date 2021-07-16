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
                
        guard let url = url else {
            showActivityIndicator()
            return
        }
        
        RRDownloadManager.shared().downloadExistsFor(url: url) { (isImageExists, imageURL, error) in
            
            if let isImageExists = isImageExists {
                
                if isImageExists {
                    
                    self.hideActivityIndicator()
                    self.imageView.image = UIImage(contentsOfFile: imageURL!.path)
                    
                } else {
                    
                    RRDownloadManager.shared().addDownloadOperation(url: url) { (downloadError) in
                        if let downloadError = downloadError {
                            RRLogger.log(type: RemoteImageContainer.self, message: downloadError.message)
                        }
                    }
                    self.showActivityIndicator()
                    
                }
                
            } else {
                RRLogger.log(type: RemoteImageContainer.self, message: error!.message)
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
    
    public func didFinishedDownload(url: URL) {

        if url == self.url {
            refreshImageView()
        }

    }
    
}
