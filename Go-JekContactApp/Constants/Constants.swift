//
//  Constants.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


struct Constants {
    static let noData = "N/A"
    static let defaultErrorMessage = "Something went worng, please try again later."
    static let noResultsErrorMessage = "No results found."
    static let defaultProfilePicHost = "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/000/008"
}

struct WebEngineConstant {
    static let baseURL = "http://gojek-contacts-app.herokuapp.com"
    static let getContactListURL = "/contacts.json"
    static let updateContactURL = "/contacts"
    static let addContactURL = "/contacts.json"
}
