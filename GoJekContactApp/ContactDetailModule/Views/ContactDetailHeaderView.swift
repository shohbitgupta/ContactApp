//
//  ContactDetailHeaderView.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import UIKit

protocol ContactDetailHeaderActionProtocol : AnyObject {
    func buttonTapped(withType buttonType : ButtonType, withStatus status : Bool)
}


enum ButtonType : Int {
    case call, message, email, favorite, camera
}

class ContactDetailHeaderView: UIView {
    
    weak var delegate : ContactDetailHeaderActionProtocol?
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var favButton: CustomControl!
    @IBOutlet weak var emailButton: CustomControl!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var callButton: CustomControl!
    @IBOutlet weak var messageButton: CustomControl!
    
    @IBOutlet weak var picBackView: UIView!
    
    /*
     @IBOutlet weak var emailButton: UIButton!
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 60
        userImageView.layer.masksToBounds = true
        favButton.delegate = self
        callButton.delegate = self
        messageButton.delegate = self
        emailButton.delegate = self
    }
    
}

extension ContactDetailHeaderView : HeaderViewUpdateProtocol {
    func updateView(withData data : ContactModelProtocol?,  status : Bool) {
        if status {
            if let urlStr = data?.profile_pic {
                let status = urlStr.isValidURL()
                if status , let urlVal = URL(string: urlStr) {
                    userImageView.setImage(withUrl: urlVal, ofSize: CGSize(width: 121, height: 121))
                }
            }
        }
        userNameLabel.text = data?.fullName
        let state = data?.favorite ?? false
        favButton.isSelected = state
    }
    
    func initialSetup() {
        callButton.updateView(withImage: "call_button", text: "Call")
        messageButton.updateView(withImage: "message_button", text: "Message")
        emailButton.updateView(withImage: "email_button", text: "Email")
        favButton.updateView(withImage: "fav_button", text: "Favorite")
        cameraButton.accessibilityIdentifier = "camera_button"
        if let imageSize = userImageView.image?.size {
            picBackView.layer.cornerRadius = imageSize.width/2
        }
    }
    
    func toggleButtonsAndLabelVisibleState() {
        callButton.isHidden = true
        favButton.isHidden = true
        emailButton.isHidden = true
        messageButton.isHidden = true
        userNameLabel.isHidden = true
        cameraButton.isHidden = false
    }
}

//Private Method Extension

extension ContactDetailHeaderView {
    @IBAction private func buttonTapped(_ sender: Any) {
        delegate?.buttonTapped(withType: .camera, withStatus: false)
    }
}

extension ContactDetailHeaderView : ButtonActionProtocol {
    func buttonTapped(sender : Any) {
        if let button = sender as? CustomControl {
            switch button.tag {
            case 0:
                delegate?.buttonTapped(withType: .message, withStatus: false)
            case 1:
                delegate?.buttonTapped(withType: .call, withStatus: false)
            case 2:
                delegate?.buttonTapped(withType: .email, withStatus: false)
            case 3:
                favButton.isSelected = !favButton.isSelected
                delegate?.buttonTapped(withType: .favorite, withStatus: favButton.isSelected)
            default:
                print("None")
            }
        }
    }
}
