//
//  SearchViewController.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/17/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var searchField = UITextField()
    var searchBarButtonItem = UIBarButtonItem()
    var label = UILabel()
    var loadingSpinner = UIActivityIndicatorView(style: .whiteLarge)
    var photos = [Photo]()
    var photosResponse: PhotosResponse?
    var page = 1
    let perPage = 25
    let searchService = FlickrSearchService.shared
    var searchText: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var backgroundView: UIView {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        let imageView = UIImageView(frame: bg.frame)
        let image = UIImage(imageLiteralResourceName: "bg")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: 30.0))
        label.center.y = view.center.y - label.frame.height - 16.0
        label.center.x = view.center.x
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.text = "Fetching images..."
        label.isHidden = true
        label.contentMode = .center
        
        loadingSpinner.center.x = view.center.x
        loadingSpinner.center.y = view.center.y
        loadingSpinner.stopAnimating()
        
        
        bg.addSubview(imageView)
        bg.addSubview(label)
        bg.addSubview(loadingSpinner)
        return bg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupSearchField()
        self.setupSearchButton()
        self.setupCollectionView()
    }
    
    func setupNavigationBar() {
        self.title = "Flickr Findr"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = Colors.pink
    }
    
    func setupSearchField() {
        searchField.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 100, height: 32)
        searchField.font = UIFont.systemFont(ofSize: 18)
        searchField.backgroundColor = .white
        searchField.tintColor = .black
        searchField.layer.cornerRadius = 8.0
        searchField.addLeftPadding(padding: 8)
        searchField.clearButtonMode = .always
        searchField.autocorrectionType = .no
        searchField.autocapitalizationType = .none
        searchField.placeholder = "Search for photos"
        searchField.delegate = self
        searchField.returnKeyType = .search
        searchField.addTarget(self, action: #selector(searchFieldDidChange), for: .editingChanged)
        
        let barButtonItem = UIBarButtonItem(customView: searchField)
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func setupSearchButton() {
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 32))
        searchButton.layer.cornerRadius = 8.0
        searchButton.addTarget(self, action: #selector(searchForPhotos), for: .touchUpInside)
        searchButton.setImage(#imageLiteral(resourceName: "search_icon"), for: .normal)
        searchButton.tintColor = .white
        searchButton.isEnabled = false
        
        searchBarButtonItem = UIBarButtonItem(customView: searchButton)
        searchBarButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = searchBarButtonItem
    }
    
    func setupCollectionView() {
        self.collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.backgroundColor = .orange
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        self.collectionView.backgroundView = backgroundView
        
        self.view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
    
    func setIsLoading(isloading: Bool) {
        if isloading {
            if let searchText = searchField.text {
                label.text = "Fetching images pertaining to \(searchText)"
                label.sizeToFit()
            }
            label.isHidden = false
            loadingSpinner.startAnimating()
        } else {
            label.isHidden = true
            loadingSpinner.stopAnimating()
        }
    }
    
    func fetchPhotos(forPage page: Int = 1) {
        self.photos.removeAll()
        self.collectionView.reloadData()
        setIsLoading(isloading: true)
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
        self.searchText = searchField.text
        self.fetchPhotos()
        self.searchField.resignFirstResponder()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchForPhotos()
        return true
    }
    
    @objc func searchFieldDidChange() {
        if let count = searchField.text?.count, count > 0 {
            searchBarButtonItem.isEnabled = true
        } else {
            searchBarButtonItem.isEnabled = false
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PhotoCollectionCell {
            let photo = self.photos[indexPath.row]
            cell.photo = photo
            return cell
        }
        return UICollectionViewCell()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            page += 1
            loadMore(atPage: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.row]
        
        let photoDetailVC = PhotoDetailViewController()
        photoDetailVC.photo = selectedPhoto
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
