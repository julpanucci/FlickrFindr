//
//  SearchViewController.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/17/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.reloadData()
        return collectionView
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.isHidden = true
        label.contentMode = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var scrollToTopButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "scroll_up"), for: .normal)
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var backgroundView = UIView()
    
    var loadingSpinner = UIActivityIndicatorView(style: .whiteLarge)
    var photos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                if self.photos.count > 0 {
                    self.scrollToTopButton.isHidden = false
                } else {
                    self.scrollToTopButton.isHidden = true
                }
            }
        }
    }
    var photosResponse: PhotosResponse?
    var page = 1
    let perPage = 25
    let searchService = FlickrSearchService.shared
    var searchText: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.setupBackgroundView()
        self.setupNavigationBar()
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(collectionView)
        self.view.bringSubviewToFront(collectionView)
        
        scrollToTopButton.addTarget(self, action: #selector(scrollToTopButtonTapped), for: .touchUpInside)
        scrollToTopButton.isHidden = true
        self.view.addSubview(scrollToTopButton)
        self.view.bringSubviewToFront(scrollToTopButton)
        
        self.setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            
            scrollToTopButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            scrollToTopButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: view.bounds.height / 2 - 50),
            scrollToTopButton.heightAnchor.constraint(equalToConstant: 46),
            scrollToTopButton.widthAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    @objc func scrollToTopButtonTapped() {
        if self.photos.count > 0 {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupNavigationBar() {
        self.title = "Search"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setupBackgroundView() {
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        let imageView = UIImageView(frame: backgroundView.frame)
        let image = UIImage(imageLiteralResourceName: "bg")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.stopAnimating()
        
        backgroundView.addSubview(imageView)
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(loadingSpinner)
        
        NSLayoutConstraint.activate([
            descriptionLabel.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width - 32),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30.0),
            descriptionLabel.centerYAnchor.constraint(equalTo: loadingSpinner.centerYAnchor, constant: -50),
            descriptionLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            loadingSpinner.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundView = backgroundView
        collectionView.reloadData()
    }
    
    func setIsLoading(isloading: Bool) {
        if isloading {
            if let searchText = self.searchText {
                descriptionLabel.text = "Searching for images about \(searchText)"
                descriptionLabel.sizeToFit()
            }
            descriptionLabel.isHidden = false
            loadingSpinner.startAnimating()
        } else {
            descriptionLabel.isHidden = true
            loadingSpinner.stopAnimating()
        }
    }
    
    private func clearPhotos() {
        self.photos.removeAll()
        self.collectionView.reloadData()
    }
    
    func fetchPhotos(forPage page: Int = 1) {
        self.clearPhotos()
        
        self.setIsLoading(isloading: true)
        
        if let searchText = self.searchText {
            searchService.fetchPhotosFrom(searchText: searchText, page: page, perpage: perPage) { (response) in
                self.photosResponse = response
                if let photos = self.photosResponse?.photos {
                    self.photos = photos
                }
                DispatchQueue.main.async {
                    self.setIsLoading(isloading: false)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func loadMore(atPage page: Int) {
        if let searchText = self.searchText {
            searchService.fetchPhotosFrom(searchText: searchText, page: page, perpage: self.perPage) { (response) in
                self.photosResponse = response
                if let photos = self.photosResponse?.photos {
                    self.photos.append(contentsOf: photos)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func searchForPhotos() {
        self.fetchPhotos()
        self.view.endEditing(true)
    }
}

extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.4) {
                self.scrollToTopButton.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.scrollToTopButton.alpha = 0.0
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchText = textField.text
        self.searchForPhotos()
        return true
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 ,let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as? SearchCell {
            cell.titleLabel.text = "Flickr Findr"
            cell.searchField.delegate = self
            return cell
        }
        if indexPath.section == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionCell {
                let photo = self.photos[indexPath.row]
                cell.photo = photo
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == photos.count - 1 {
                page += 1
                loadMore(atPage: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let selectedPhoto = photos[indexPath.row]
            
            let photoDetailVC = PhotoDetailViewController()
            photoDetailVC.photo = selectedPhoto
            self.navigationController?.pushViewController(photoDetailVC, animated: true)
        }
        
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.bounds.width - 32, height: 100)
        }
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
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
