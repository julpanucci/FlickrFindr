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
    
    var searches = [Search]()
    var delegate: MultiCastRecentSearchesDelegate?
    
    func addNewSearch(search: Search) {
        if !searches.contains(where: { (currentSearch) -> Bool in
            currentSearch.searchText == search.searchText
        }) {
            searches.append(search)
            delegate?.searchesDidUpdate(searches: self.searches)
        }
    }
}

@objc protocol RecentSearchesDelegate {
    @objc optional func searchesDidUpdate(searches: [Search])
    @objc optional func searchWasSelected(search: Search)
}

class MulticastDelegate<T> {

    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    func remove(_ delegateToRemove: T) {
        for delegate in delegates.allObjects.reversed() {
            if delegate === delegateToRemove as AnyObject {
                delegates.remove(delegate)
            }
        }
    }

    func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}

class MultiCastRecentSearchesDelegate: RecentSearchesDelegate {
    func searchWasSelected(search: Search) {
        multicast.invoke { (delegate) in
            delegate.searchWasSelected?(search: search)
        }
    }
    
    func searchesDidUpdate(searches: [Search]) {
        multicast.invoke { (delegate) in
            delegate.searchesDidUpdate?(searches: searches)
        }
    }

    let multicast = MulticastDelegate<RecentSearchesDelegate>()

    init(_ delegates: [RecentSearchesDelegate]) {
        delegates.forEach(multicast.add)
    }
    
    func add(_ delegates: [RecentSearchesDelegate]) {
        delegates.forEach(multicast.add)
    }
}
