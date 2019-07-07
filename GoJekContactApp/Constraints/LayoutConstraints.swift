//
//  LayoutConstraints.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import UIKit

class LayoutScalingConstraint: NSLayoutConstraint {
    
    override var constant: CGFloat {
        set {
            
        }
        get {
            return LayoutScalingConstraint.scaleValue(value: super.constant)
        }
    }
    
    static func scaleValue(value : CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.size.width
        let scalefactor = width/414
        return value*scalefactor
    }
}
