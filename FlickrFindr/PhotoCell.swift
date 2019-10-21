//
//  PhotoCell.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/18/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UITableViewCell {
    
    var photoView = UIImageView()
    var titleLabel = UILabel()
    var photo: Photo?
    let placeHolder = UIImage(named: "placeholder.png")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpPhotoView()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func setUpPhotoView() {
        self.photoView = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        self.photoView.contentMode = .scaleAspectFill
        self.photoView.backgroundColor = .gray
        self.photoView.layer.cornerRadius = 10.0
        self.photoView.clipsToBounds = true
        
        self.contentView.addSubview(photoView)
        self.photoView.translatesAutoresizingMaskIntoConstraints = false
        self.photoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
        self.photoView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        self.photoView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.photoView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        if let url = photo?.thumbnailURL {
            photoView.kf.setImage(with: url, placeholder: placeHolder)
        }
    }
    
    func setupTitleLabel() {
        titleLabel.frame = CGRect(x: 200, y: 0, width: 200, height: 22.0)
        titleLabel.font = UIFont.systemFont(ofSize: 22.0)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        
        self.contentView.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.photoView.trailingAnchor, constant: 8).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    
}
