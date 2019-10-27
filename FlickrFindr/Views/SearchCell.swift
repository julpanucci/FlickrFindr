//
//  SearchCell.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/26/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    var searchField: UITextField  = {
        let searchField = UITextField()
        searchField.textColor = .black
        searchField.font = UIFont.systemFont(ofSize: 18)
        searchField.backgroundColor = .white
        searchField.tintColor = .black
        searchField.layer.cornerRadius = 4.0
        searchField.clearButtonMode = .always
        searchField.autocorrectionType = .no
        searchField.autocapitalizationType = .none
        searchField.placeholder = "Search"
        searchField.returnKeyType = .search
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        let searchIcon = UIImageView(image: UIImage(named: "search_icon"))
        searchIcon.tintColor = .black
        
        searchField.leftView = searchIcon
        searchField.leftViewMode = .always
        
        return searchField
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(searchField)
        self.contentView.addSubview(titleLabel)
        
        self.setContraints()
    }
    
    func setContraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            searchField.heightAnchor.constraint(equalToConstant: 40),
            searchField.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 60)
        ])
    }
    
}
