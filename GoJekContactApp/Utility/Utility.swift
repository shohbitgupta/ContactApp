//
//  Utility.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isAlphanumeric() -> Bool {
        var characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
        characterSet.formUnion(CharacterSet.whitespaces)
        let mySet = CharacterSet(charactersIn: self)
        let status = characterSet.isSuperset(of: mySet)
        return status
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidatePhoneNumber() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isValidURL() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
                // it is a link, if the match covers the whole string
                return match.range.length == self.endIndex.encodedOffset
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func size(for font: UIFont?, width: CGFloat) -> CGSize {
        if font == nil {
            return CGSize.zero
        }
        
        var attrString: NSAttributedString? = nil
        if let font = font {
            attrString = NSAttributedString(string: self, attributes: [
                NSAttributedString.Key.font: font
                ])
        }
        return self.size(for: attrString, width: width)
    }
    
    private func size(for attrString: NSAttributedString?, width: CGFloat) -> CGSize {
        if attrString == nil {
            return CGSize.zero
        }
        
        let size = attrString?.boundingRect(with: CGSize(width: width, height: CGFloat(UInt.max)), options: .usesLineFragmentOrigin, context: nil)
        
        return CGSize(width: ceil(size?.width ?? 0), height: ceil(size?.height ?? 0))
    }
}

extension UIFont {
    static func regular(_ size : CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func semiBold(_ size : CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func light(_ size : CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .light)
    }
}
