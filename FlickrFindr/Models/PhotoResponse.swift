//
//  PhotoResponse.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/27/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import Foundation

class PhotosResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perpage = "perpage"
        case total = "total"
        case photos = "photo"
    }
    
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photos: [Photo]?
}
