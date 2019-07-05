//
//  ErrorView.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import UIKit

class TableErrorView: UIView {
    
    let label : UILabel
    
    init?(text: String) {
        if text.count == 0 {
            return nil
        }
        
        label = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        label.font = UIFont.light(16.0)
        label.textColor = UIColor.init(white: 0.6, alpha: 1.0)
        label.text = text
        label.textAlignment = .center
        
        super.init(frame: CGRect.zero)
        
        addSubview(label)
        
        let mainScreenRect: CGRect = UIScreen.main.bounds
        let availableWidth: CGFloat = mainScreenRect.size.width - 2 * TableErrorViewConstants.loaderViewTopPadding
        let size: CGSize = text.size(for: label.font, width: availableWidth)
        let h = CGFloat(size.height + 2.0 * TableErrorViewConstants.loaderViewTopPadding)
        
        frame = CGRect(x: 0, y: 0, width: availableWidth, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect: CGRect = bounds
        let y = TableErrorViewConstants.loaderViewTopPadding
        var size = CGSize.zero
        var x: CGFloat = 0.0
        
        if let count = label.text?.count, count > 0 {
            let mainScreenRect: CGRect = UIScreen.main.bounds
            let availableWidth: CGFloat = mainScreenRect.size.width - 2 * TableErrorViewConstants.loaderViewTopPadding
            size = label.text?.size(for: label.font, width: availableWidth) ?? CGSize.zero
            x = (rect.size.width - size.width)/2
            label.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        }
    }
}

private struct TableErrorViewConstants {
    static let loaderViewTopPadding : CGFloat = 16.0
}

