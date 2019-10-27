//
//  FlickrSearchResponse.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/27/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import Foundation

class FlickrSearchResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case photosResponse = "photos"
        case status = "stat"
    }
    var photosResponse: PhotosResponse?
    var status: String?
}
