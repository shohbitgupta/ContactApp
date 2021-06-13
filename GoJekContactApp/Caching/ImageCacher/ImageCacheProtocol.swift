//
//  ImageCacheProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import UIKit

/**
 This Protocol is to provide requirements for making any UIImageView object for downloading images from server.
 */

protocol ImageCacheProtocol {
    func setImage(withUrl imageURL : URL, ofSize newSize : CGSize)
    func setImage(withUrl imageURL : URL, ofSize newSize : CGSize, withPlaceHolderImage placeHolderImage : UIImage?)
    func setImage(withUrl imageURL : URL, ofSize newSize : CGSize, withPlaceHolderImage placeHolderImage : UIImage?, successCompletion successCallback : ((URLRequest, URLResponse?, UIImage?) -> Void)?, failureCompletion failureCallback : ((URLRequest, URLResponse?, CustomErrorProtocol?) -> Void)?)
}
