//
//  ImageDownloadingProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import UIKit


/**
 This Protocol is to provide requirements for making any type as status type for webservice made to server.
 */

protocol ImageDownloadStatusProtocol {
    var dataTask : URLSessionDataTask { get }
    var downloadID : String { get }
    init(dataTask task : URLSessionDataTask, downloadID identifier : String)
}


/**
 This Protocol is to provide requirements for making any object as image downlaod manager for fetching image from server.
 */

protocol ImageDownloaderProtocol {
    func downLoadImage(withURLRequest request : URLRequest, downloadID identifier : String, ofSize newSize : CGSize, successCompletion : @escaping (URLRequest, URLResponse?, UIImage?) -> Void, failureCompletion : @escaping (URLRequest, URLResponse?, CustomErrorProtocol?) -> Void) -> ImageDownloadStatus?
    func cancelDownload(forStatus downloadStatus : ImageDownloadStatusProtocol)
    func getImage(forIdentifier identifier : String, withSize size : CGSize) -> UIImage?
    func clearAllCachedData()
}

/**
 This Protocol is to provide requirements for making any object as callback object for webservice made to server.
 */

protocol ImageTaskHandlerProtocol {
    init(downloadId identifier : String, success : @escaping (URLRequest, URLResponse?, UIImage?) -> Void, failure : @escaping (URLRequest, URLResponse?, CustomErrorProtocol?) -> Void)
}

/**
 This Protocol is to provide requirements for making any object as webservice object for tracking webservice made to server.
 */

protocol ImageDownloadTaskProtocol {
    init(dataTask task : URLSessionDataTask, taskID identifier : String)
    func addTaskHandler(handler : ImageTaskHandler)
    func removeHandler(handler : ImageTaskHandler)
}

