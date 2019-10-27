//
//  RecentSearchesViewController.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/26/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

class RecentSearchesViewController: UICollectionViewController {
    
    let identifier = "RecentSearchCell"
    
    let manager = RecentSearchesManager.shared
    var recentSearches = [Search]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.reloadData()
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        if let layout = layout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            layout.minimumLineSpacing = 1.0
            layout.minimumInteritemSpacing = 1.0
        }
        
        super.init(collectionViewLayout: layout)
        
        self.collectionView.register(RecentSearchCell.self, forCellWithReuseIdentifier: identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recentSearches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as? RecentSearchCell {
            
            let search = self.recentSearches[indexPath.row]
            cell.search = search
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let search = self.recentSearches[indexPath.row]
        manager.delegate?.searchWasSelected(search: search)
    }
}

extension RecentSearchesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return RecentSearchCell.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
}

extension RecentSearchesViewController: RecentSearchesDelegate {
    func searchesDidUpdate(searches: [Search]) {
        self.recentSearches = searches
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
