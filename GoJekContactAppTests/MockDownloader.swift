//
//  MockDownloaderTest.swift
//  GoJekContactAppTests
//
//  Created by B0203470 on 07/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import XCTest
@testable import GoJekContactApp

class ErrorObject: Error {
    
}
class MockDownloaderTest: ImageDownloaderProtocol {
    
    func downLoadImage(withURLRequest request : URLRequest, downloadID identifier : String, ofSize newSize : CGSize, successCompletion : @escaping (URLRequest, URLResponse?, UIImage?) -> Void, failureCompletion : @escaping (URLRequest, URLResponse?, CustomErrorProtocol?) -> Void) -> ImageDownloadStatus? {
        return nil
    }
    
    func cancelDownload(forStatus downloadStatus : ImageDownloadStatusProtocol) {
        
    }
    
    func getImage(forIdentifier identifier : String, withSize size : CGSize) -> UIImage? {
        return nil
    }
    
    func clearAllCachedData() {
        
    }
}
