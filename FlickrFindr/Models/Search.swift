//
//  Search.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/27/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

@objc class Search: NSObject, Codable {
    var searchText: String?
    var imageURL: URL?
    
    convenience init(searchText: String?, imageURL: URL?) {
        self.init()
        self.searchText = searchText
        self.imageURL = imageURL
    }
}
