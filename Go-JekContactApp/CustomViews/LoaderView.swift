//
//  LoaderView.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    
    let activityIndicator : UIActivityIndicatorView
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    init() {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = UIColor.init(white: 0.3, alpha: 1.0)
        
        super.init(frame: CGRect.zero)
        
        addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        backgroundColor = UIColor.clear
        
        let size: CGSize = activityIndicator.bounds.size
        self.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height + 2.0 * LoaderViewConstants.loaderViewTopPadding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect: CGRect = bounds
        activityIndicator.center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
    }
    
}

private struct LoaderViewConstants {
    static let loaderViewTopPadding : CGFloat = 16.0
}
