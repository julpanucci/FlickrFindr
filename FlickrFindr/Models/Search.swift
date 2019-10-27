//
//  Search.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/27/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

@objc class Search: NSObject {
    var searchText: String?
    var imageURL: URL?
    var color: UIColor?
    
    convenience init(searchText: String?, imageURL: URL?, color: UIColor? = .random()) {
        self.init()
        self.searchText = searchText
        self.imageURL = imageURL
        self.color = color
    }
}
