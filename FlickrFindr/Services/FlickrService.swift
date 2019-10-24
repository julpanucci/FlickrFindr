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
        components.queryItems = [URLQueryItem(name: "method", value: "flickr.photos.search"),
                                 URLQueryItem(name: "api_key", value: Strings.Keys.flickr),
                                 URLQueryItem(name: "sort", value: "relevance")]
        
        return components
    }
    
    func fetchPhotosFrom(searchText: String, page: Int = 1, perpage: Int = 20, completion: @escaping (PhotosResponse?) -> Void) {
        var components = self.urlComponents
        components.queryItems?.append(URLQueryItem(name: "text", value: searchText))
        components.queryItems?.append(URLQueryItem(name: "extras", value: "url_m,url_z,owner_name"))
        components.queryItems?.append(URLQueryItem(name: "format", value: "json"))
        components.queryItems?.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        components.queryItems?.append(URLQueryItem(name: "per_page", value: "\(perpage)"))
        components.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
        
        guard let url = components.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let searchResponse = try? JSONDecoder().decode(FlickrSearchResponse.self, from: data) else {
                return
            }
            
            if let photosResponse = searchResponse.photosResponse {
                completion(photosResponse)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
}
