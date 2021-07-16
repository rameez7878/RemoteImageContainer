//
//  UIView+Extension.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 15/07/2021.
//

import UIKit
import ShimmerSwift

extension UIView {
    
    public func addShimmer() {
        removeShimmer()
        let whiteView = UIView(frame: bounds)
        whiteView.autoresizingMask = autoresizingMask
        whiteView.tag = -123
        whiteView.backgroundColor = .white
        addSubview(whiteView)
        let baseLayer = CAGradientLayer()
        baseLayer.name = "shimmer"
        baseLayer.colors = [UIColor(hex: "#CACACA").cgColor, UIColor(hex: "#EEEEEE").cgColor]
        baseLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        baseLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        baseLayer.frame = bounds
        whiteView.layer.addSublayer(baseLayer)
        
        let shimmerView = ShimmeringView(frame: bounds)
        shimmerView.autoresizingMask = autoresizingMask
        whiteView.tag = -1234
        addSubview(shimmerView)
        
        shimmerView.contentView = whiteView
        shimmerView.isShimmering = true
        
    }
    
    public func removeShimmer() {
        viewWithTag(-123)?.removeFromSuperview()
        viewWithTag(-1234)?.removeFromSuperview()
    }
    
}
