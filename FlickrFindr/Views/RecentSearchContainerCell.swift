//
//  RecentSearchContainerCell.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/27/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

class RecentSearchContainerCell: UICollectionViewCell {
    
    static let identifier = "RecentSearchContainerCell"
    let manager = RecentSearchesManager.shared
    
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = Strings.recentSearches
        return label
    }()
    
    lazy var recentSearchesController: RecentSearchesViewController = {
        let viewController = RecentSearchesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        viewController.collectionView.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    override func layoutSubviews() {
        
        contentView.addSubview(label)
        contentView.addSubview(recentSearchesController.collectionView)
        
        recentSearchesController.collectionView.delegate = recentSearchesController
        recentSearchesController.collectionView.dataSource = recentSearchesController
        
        if manager.delegate != nil {
            manager.delegate?.add([recentSearchesController, self])
        } else {
            manager.delegate = MultiCastRecentSearchesDelegate([recentSearchesController, self])
        }
        self.setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            label.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            label.heightAnchor.constraint(equalToConstant: 18),
            
            recentSearchesController.collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: -4),
            recentSearchesController.collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            recentSearchesController.collectionView.heightAnchor.constraint(equalToConstant: 150),
            recentSearchesController.collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }
}

extension RecentSearchContainerCell: RecentSearchesDelegate {
    func searchesDidUpdate(searches: [Search]) {
        DispatchQueue.main.async {
            if searches.count > 0 {
                self.label.isHidden = false
            } else {
                self.label.isHidden = true
            }
        }
        
    }
}
