//
//  ImageDownloadingStatus.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


/**
 This Type is used for status tracking for image download service.
 */

class ImageDownloadStatus : ImageDownloadStatusProtocol {
    
    let dataTask : URLSessionDataTask
    let downloadID : String
    
    required init(dataTask task : URLSessionDataTask, downloadID identifier : String) {
        dataTask = task
        downloadID = identifier
    }
}
