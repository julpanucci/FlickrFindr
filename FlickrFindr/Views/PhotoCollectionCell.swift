//
//  PhotoCollectionCell.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/23/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCollectionCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionCell"
    
    var imageView: UIImageView = UIImageView()
    var titleLabel: UILabel = UILabel()
    var photo: Photo?
    let placeHolder = UIImage(named: "placeholder.png")
    
    override func layoutSubviews() {
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
        setupImageView()
        setupTitleLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.titleLabel.text = ""
    }
    
    func setupImageView() {
        self.imageView.backgroundColor = .blue
        self.imageView.kf.setImage(with: photo?.thumbnailURL, placeholder: placeHolder)
        self.imageView.contentMode = .scaleAspectFill
        
        let blackMask = UIView(frame: self.imageView.frame)
        blackMask.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.contentView.addSubview(blackMask)
        self.contentView.bringSubviewToFront(blackMask)
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .left
        titleLabel.text = photo?.title
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
