//
//  PhotoDetailView.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/21/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {

    let noImagePlaceholder = UIImage(named: "no_image.png")
    var photo: Photo?

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let path = Bundle.main.path(forResource: "loading2", ofType: "gif")!
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            imageView.kf.indicatorType = .image(imageData: data)
        }
        return imageView
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.sizeToFit()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var ownerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(ownerLabel)

        self.setConstraints()
        self.updateUI()
        self.fetchAndSetImage()
    }

    override func viewDidLoad() {
         super.viewDidLoad()

         self.view.backgroundColor = .black
     }

    func setConstraints() {
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),

            ownerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ownerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ownerLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            ownerLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func updateUI() {
        if let owner = photo?.owner {
            ownerLabel.text = "By: \(owner)"
        }

        if let title = photo?.title {
            titleLabel.text = title
        }
    }
    
    func fetchAndSetImage() {
        if let url = photo?.imageURL {
            imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (result) in
                switch result {
                case .failure:
                    let alert = UIAlertController(title: Strings.Error.oopsTitle, message: Strings.Error.failedImageMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (action) in
                        self.fetchAndSetImage()
                    }))
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                default:
                    break
                }
            }
        } else {
            self.imageView.image = self.noImagePlaceholder
        }
    }
}
