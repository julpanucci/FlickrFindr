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
    
    var photo: Photo?
    var imageView = UIImageView()
    let noImagePlaceholder = UIImage(named: "no_image.png")
    
    override func viewWillAppear(_ animated: Bool) {
        imageView = UIImageView(frame: CGRect(x: 8, y: 0, width: view.bounds.width - 16, height: 200))
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(imageView)
        imageView.kf.setImage(with: photo?.imageURL, placeholder: nil, options: nil, progressBlock: nil) { (result) in
            switch result {
            case .failure:
                self.imageView.image = self.noImagePlaceholder
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .orange
    }
}
