//
//  Photo.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/17/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

class FlickrSearchResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case photosResponse = "photos"
        case status = "stat"
    }
    var photosResponse: PhotosResponse?
    var status: String?
}

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

class Photo: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case imageString = "url_z"
        case thumbnailString = "url_m"
        case owner = "ownername"
    }
    
    var id: String?
    var title: String?
    var owner: String?
    private var imageString: String?
    private var thumbnailString: String?
    
    var imageURL: URL? {
        if let imageString = self.imageString {
            return URL(string: imageString)
        }
        return nil
    }
    
    var thumbnailURL: URL? {
        if let thumbString = self.thumbnailString {
            return URL(string: thumbString)
        }
        return nil
    }
}

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
