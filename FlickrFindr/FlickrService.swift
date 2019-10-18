//
//  FlickrService.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/17/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import Foundation

class FlickrSearchService {
    static let shared = FlickrSearchService()
    
    typealias json = [String: Any]
    
    let baseURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Strings.Keys.flickr)&text=cats&extras=url_o%2Curl_t&per_page=20&format=json&nojsoncallback=1"
    
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [URLQueryItem(name: "method", value: "flickr.photos.search"), URLQueryItem(name: "api_key", value: Strings.Keys.flickr)]
        return components
    }
    
    func fetchPhotosFrom(searchText: String, perpage: Int = 20) {
        var components = self.urlComponents
        components.queryItems?.append(URLQueryItem(name: "text", value: searchText))
        components.queryItems?.append(URLQueryItem(name: "extras", value: "url_o,url_t"))
        components.queryItems?.append(URLQueryItem(name: "format", value: "json"))
        components.queryItems?.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        components.queryItems?.append(URLQueryItem(name: "per_page", value: "\(perpage)"))
        
        guard let url = components.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let searchResponse = try? JSONDecoder().decode(FlickrSearchResponse.self, from: data) else {
                return
                }
            
            print(searchResponse)
            if let photosResponse = searchResponse.photosResponse, let photos = photosResponse.photos {
                for photo in photos {
                    print(photo.title!)
                }
            }
            print(1)
        }.resume()
    }
    
}
