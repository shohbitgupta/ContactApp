//
//  ImageDownloader.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import UIKit
/**
 This Type is used for fetching image data from given URL.
 */

final class ImageDownloader {
    
    static let sharedDownloader = ImageDownloader()
    var sessionManager : URLSessionManagerProtocol
    private var imageDownloadInfo : [AnyHashable : ImageDownloadTask] = [:]
    private var imageInMemoryCache : [AnyHashable : UIImage] = [:]
    private let serialQueue = DispatchQueue(label: "com.ContactApp.demo.app.serialQueue")
    private let concurrentQueue = DispatchQueue(label: "com.ContactApp.demo.app.concurrentQueue", attributes: .concurrent)
    
    private init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = ImageDownloader.urlCache()
        sessionConfig.requestCachePolicy = .useProtocolCachePolicy
        sessionManager = URLSessionManager.sessionManager(withConfiguration: sessionConfig, withBaseURL: nil)
    }
    
    private static func urlCache() -> URLCache {
        let urlCache = URLCache(memoryCapacity: 50*1024*1024, diskCapacity: 200*1024*1024, diskPath: "com.ContactAppimage.downloader")
        return urlCache
    }
}

extension ImageDownloader : ImageDownloaderProtocol {
    
    func clearAllCachedData() {
        imageDownloadInfo.removeAll()
        imageInMemoryCache.removeAll()
    }
    
    func downLoadImage(withURLRequest request : URLRequest, downloadID identifier : String, ofSize newSize : CGSize, successCompletion : @escaping (URLRequest, URLResponse?, UIImage?) -> Void, failureCompletion : @escaping (URLRequest, URLResponse?, CustomErrorProtocol?) -> Void) -> ImageDownloadStatus? {
        
        guard let urlID = request.url?.absoluteString else {
            let err = DataError()
            DispatchQueue.main.async {
                failureCompletion(request, nil, err)
            }
            return nil
        }
        
        var dataTask : URLSessionDataTask?
        
        serialQueue.sync {
            if let downloadTask = imageDownloadInfo[urlID] {
                let handler = ImageTaskHandler(downloadId : identifier, success: successCompletion, failure: failureCompletion)
                downloadTask.addTaskHandler(handler: handler)
                dataTask = downloadTask.dataTask
            }
            else {
                let task = sessionManager.dataTask(withRequest: request) { [weak self] (response, data, error) in
                    self?.concurrentQueue.async {
                        if let imageDwnldTask = self?.imageDownloadInfo[urlID] {
                            if let err = error {
                                for handler in imageDwnldTask.handlerList {
                                    DispatchQueue.main.async {
                                        handler.failureCallBack(request, response, err)
                                    }
                                }
                                self?.serialyRemoveInMemoryCachedImage(withIdentifier: urlID, withSize: newSize)
                                self?.serialyRemoveTask(withIdentifier: urlID)
                            }
                            else {
                                for handler in imageDwnldTask.handlerList {
                                    guard let dataVal = data as? Data, let image = UIImage(data: dataVal) else {
                                        DispatchQueue.main.async {
                                            handler.successCallBack(request, response, nil)
                                        }
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        if let newImage = self?.convertImageToGivenSize(image: image, newSize: newSize) {
                                            self?.serialyAddInMemoryCachedImage(withIdentifier: urlID, image: newImage, withSize: newSize)
                                            handler.successCallBack(request, response, newImage)
                                        }
                                        else {
                                            handler.successCallBack(request, response, nil)
                                        }
                                    }
                                }
                                self?.serialyRemoveTask(withIdentifier: urlID)
                            }
                        }
                    }
                }
                
                let handler = ImageTaskHandler(downloadId : identifier, success: successCompletion, failure: failureCompletion)
                let downloadTask = ImageDownloadTask(dataTask: task, taskID: urlID)
                downloadTask.addTaskHandler(handler: handler)
                addTask(dataTask: downloadTask, identifier: urlID)
                dataTask = task
            }
        }
        
        if let taskVal = dataTask {
            taskVal.resume()
            return ImageDownloadStatus(dataTask: taskVal, downloadID: identifier)
        }
        else {
            return nil
        }
    }
    
    func cancelDownload(forStatus downloadStatus : ImageDownloadStatusProtocol) {
        serialQueue.sync {
            if let urlId = downloadStatus.dataTask.originalRequest?.url?.absoluteString {
                if let downloadTask = imageDownloadInfo[urlId] {
                    var handlerVal : ImageTaskHandler?
                    for handler in downloadTask.handlerList {
                        if handler.dwnldID == downloadStatus.downloadID, let urlReq = downloadTask.dataTask.originalRequest {
                            DispatchQueue.main.async {
                                handler.failureCallBack(urlReq, nil, DataError())
                            }
                            handlerVal = handler
                        }
                    }
                    if let val = handlerVal {
                        downloadTask.removeHandler(handler: val)
                        if downloadTask.handlerList.count == 0 {
                            downloadTask.dataTask.cancel()
                            removeTask(withIdentifier: urlId)
                        }
                    }
                }
            }
        }
    }
    
    func getImage(forIdentifier identifier : String, withSize size : CGSize) -> UIImage? {
        let finalID = identifier + "\(size.width)X\(size.height)"
        return imageInMemoryCache[finalID]
    }
    
    func addTask(dataTask : ImageDownloadTask, identifier : String) {
        if let _ = imageDownloadInfo[identifier] {
        }
        else {
            imageDownloadInfo[identifier] = dataTask
        }
    }
    
    func removeTask(withIdentifier identifier : String) {
        if let _ = imageDownloadInfo[identifier] {
            imageDownloadInfo.removeValue(forKey: identifier)
        }
    }
}

// Private Method Extension

extension ImageDownloader {
    
    private func serialyRemoveInMemoryCachedImage(withIdentifier identifier : String, withSize size : CGSize) {
        serialQueue.sync {
            removeImage(withIdentifier: identifier, withSize: size)
        }
    }
    
    private func convertImageToGivenSize(image : UIImage, newSize : CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func serialyRemoveTask(withIdentifier identifier : String) {
        serialQueue.sync {
            removeTask(withIdentifier: identifier)
        }
    }
    
    private func serialyAddInMemoryCachedImage(withIdentifier identifier : String, image : UIImage, withSize size : CGSize) {
        serialQueue.sync {
            let finalID = identifier + "\(size.width)X\(size.height)"
            if let _ = imageInMemoryCache[finalID] {
                
            }
            else {
                imageInMemoryCache[finalID] = image
            }
        }
    }
    
    private func removeImage(withIdentifier identifier : String, withSize size : CGSize) {
        let finalID = identifier + "\(size.width)X\(size.height)"
        imageInMemoryCache.removeValue(forKey: finalID)
    }
}
