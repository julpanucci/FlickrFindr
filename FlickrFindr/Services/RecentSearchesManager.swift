//
//  RecentSearchesManager.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/27/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import Foundation

class RecentSearchesManager {
    
    static let shared = RecentSearchesManager()
    
    private var searches = [Search]()
    var delegate: RecentSearchesDelegate?
    
    func addNewSearch(search: Search) {
        if !searches.contains(where: { (currentSearch) -> Bool in
            currentSearch.searchText == search.searchText
        }) {
            searches.append(search)
            delegate?.searchesDidUpdate(searches: self.searches)
        }
    }
    
    
}

protocol RecentSearchesDelegate {
    func searchesDidUpdate(searches: [Search])
}
