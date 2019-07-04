//
//  CustomControl.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


import UIKit

class CustomControl: UIControl {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var buttonTitleLabel: UILabel!
    @IBOutlet var customView: UIView!
    
    weak var delegate : ButtonActionProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

extension CustomControl : CustomControlProtocol {
    func updateView(withImage imageName : String, text : String) {
        imageButton.setImage(UIImage(named: imageName), for: .normal)
        buttonTitleLabel.text = text
        imageButton.accessibilityIdentifier = imageName
    }
}

//Private Method Extension

extension CustomControl {
    @IBAction private func buttonTapped(_ sender: Any) {
        delegate?.buttonTapped(sender : self)
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CustomControl", owner: self, options: nil)
        addSubview(customView)
        customView.frame = self.bounds
        customView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
    }
}
