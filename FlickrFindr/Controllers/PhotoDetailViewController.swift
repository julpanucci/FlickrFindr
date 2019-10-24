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
    var titleLabel = UILabel()
    let noImagePlaceholder = UIImage(named: "no_image.png")
    
    override func viewWillAppear(_ animated: Bool) {
        imageView = UIImageView(frame: CGRect(x: 8, y: 0, width: view.bounds.width - 16, height: 200))
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .left
        titleLabel.text = photo?.title
        titleLabel.frame.origin = CGPoint(x: 8, y: imageView.frame.maxY + 16)
        titleLabel.frame.size = CGSize(width: view.bounds.width - 16, height: 28)
        
        self.view.addSubview(titleLabel)
        
        let path = Bundle.main.path(forResource: "loading2", ofType: "gif")!
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            imageView.kf.indicatorType = .image(imageData: data)
        }
        
        imageView.kf.setImage(with: photo?.imageURL, options: [.transition(.fade(0.2))])
        
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
        
        self.view.backgroundColor = .black
    }
}
