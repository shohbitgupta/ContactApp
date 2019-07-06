//
//  HomeContactCell.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import UIKit

class HomeContactCell: UITableViewCell, ViewUpdateProtocol {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateView(withData data : ContactModelProtocol?) {
        userNameLabel.text = data?.fullName
        let state = data?.favorite ?? false
        favoriteButton.isHidden = !state
        let placeHolderImage = UIImage(named: "placeholder_photo")
        userImageView.image = placeHolderImage
        if let usrlStr = data?.profile_pic {
            let status = usrlStr.isValidURL()
            if status, let urlVal = URL(string: usrlStr) {
                userImageView.setImage(withUrl: urlVal, ofSize: CGSize(width: 40, height: 40), withPlaceHolderImage: placeHolderImage, successCompletion: { [weak self] (request, response, image) in
                    self?.userImageView.image = image ?? placeHolderImage
                }) { (request, response, error) in
                    
                }
            }
        }
    }
}



