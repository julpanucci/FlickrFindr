//
//  RecentSearchCell.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/27/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

class RecentSearchCell: UICollectionViewCell {
    var searchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.sizeToFit()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var search: Search?
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
        self.contentView.addSubview(searchLabel)
        self.setContraints()
        self.updateUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setContraints() {
        
        NSLayoutConstraint.activate([
            searchLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            searchLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            searchLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func updateUI() {
        self.contentView.backgroundColor = .random()
        self.searchLabel.text = search?.searchText
    }
}
