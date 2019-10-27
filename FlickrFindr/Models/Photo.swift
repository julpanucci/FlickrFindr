//
//  Photo.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/17/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit



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


