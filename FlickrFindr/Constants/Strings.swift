//
//  Strings.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/17/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import Foundation

struct Strings {
    
    struct Keys {
        static let flickr = "1508443e49213ff84d566777dc211f2a"
    }
    
    struct Error {
        static let oopsTitle = "Oops"
        static let failedImageMessage = "There was a problem fetching your image! Would you like to try again?"
        static let failedFetchForImages = "Something went wrong fetching your images. Would you like to try again?"
    }
    
    static let search = "Search"
    static let searchDescription = "Searching for images about"
    static let flickrFindrTitle = "Flickr Findr"
    static let tryAgain = "Try Again"
    static let dismiss = "Dismiss"
    static let ownerLabel = "By:"
    static let recentSearches = "Recent Searches"
}
