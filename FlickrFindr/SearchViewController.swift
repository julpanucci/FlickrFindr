//
//  SearchViewController.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/17/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var tableView = UITableView()
    var photos = [Photo]()
    
    var emptyView: UIView {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        emptyView.backgroundColor = Colors.orange
        
        let searchImage = UIImage(named: "search_2.png")
        let imageView = UIImageView(image: searchImage)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.center.y = view.center.y
        imageView.center.x = view.center.x
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: 30.0))
        label.center.y = imageView.frame.maxY + 24.0
        label.center.x = view.center.x
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.text = "No images"
        
        
        emptyView.addSubview(imageView)
        emptyView.addSubview(label)
        return emptyView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "FlickrFindr"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setupTableView()
        self.setupSearchController()
        self.navigationController?.navigationBar.barTintColor = .orange
    }
    
    func setupSearchController() {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search photos"
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.black
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.delegate = self
        searchBar.isTranslucent = true
        
        tableView.tableHeaderView = searchBar
    }
    
    func setupTableView() {
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PhotoCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundView = emptyView
        
        self.view.addSubview(tableView)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let photoCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PhotoCell {
            let photo = photos[indexPath.row]
            photoCell.photo = photo
            
            return photoCell
        }
        
        return UITableViewCell()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            FlickrSearchService.shared.fetchPhotosFrom(searchText: searchText) { (photos) in
                if let photosFetched = photos {
                    self.photos = photosFetched
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        searchBar.resignFirstResponder()
    }
}
