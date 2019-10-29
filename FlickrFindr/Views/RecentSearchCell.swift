//
//  RecentSearchCell.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/27/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

class RecentSearchCell: UICollectionViewCell {
    
    static let size: CGSize = CGSize(width: 75.0, height: 75.0)
    
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
    
    var color: UIColor?
    var search: Search?
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        
        self.contentView.addSubview(searchLabel)

        
        self.contentView.bringSubviewToFront(searchLabel)
        self.setContraints()
        
        self.searchLabel.text = search?.searchText
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.searchLabel.text = nil
    }
    
    func setContraints() {
        NSLayoutConstraint.activate([
            searchLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            searchLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            searchLabel.heightAnchor.constraint(equalToConstant: 23),
        ])
    }
}
