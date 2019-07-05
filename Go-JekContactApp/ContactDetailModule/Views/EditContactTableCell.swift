//
//  EditContactTableCell.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import UIKit

class EditContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var leftLabel: UILabel!
    weak var delegate : TextDetailUpdateProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editTextField.inputAssistantItem.leadingBarButtonGroups = []
        editTextField.inputAssistantItem.trailingBarButtonGroups = []
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension EditContactTableViewCell : ViewUpdateProtocol {
    
    func updateView(withData data : ContactDeatilFormDataProtocol?) {
        leftLabel.text = data?.leftData
        editTextField.text = data?.rightData
        editTextField.keyboardType = getKeyBoardType(type: data?.keyType)
    }
}

extension EditContactTableViewCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textUpdated(withText: textField.text, index: textField.tag)
    }
}

extension EditContactTableViewCell {
    private func getKeyBoardType(type : KeyBoardType?) -> UIKeyboardType {
        guard let typeVal = type else {
            return .default
        }
        
        switch typeVal {
        case .normal:
            return .default
        case .email:
            return .emailAddress
        case .numberPad:
            return .numberPad
        }
    }
}
