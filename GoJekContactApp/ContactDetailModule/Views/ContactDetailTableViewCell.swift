//
//  ContactDetailTableViewCell.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import UIKit
class ContactDetailCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension ContactDetailCellTableViewCell : ViewUpdateProtocol {
    
    func updateView(withData data : ContactDeatilFormDataProtocol?) {
        leftLabel.text = data?.leftData
        rightLabel.text = data?.rightData
    }
}
