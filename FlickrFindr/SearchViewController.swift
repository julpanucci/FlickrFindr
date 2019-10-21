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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
        
        self.setupTableView()
        self.setupSearchController()
        self.navigationController?.navigationBar.barTintColor = Colors.blue
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
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        searchBar.isTranslucent = true
    }
    
    func setupTableView() {
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PhotoCell.self, forCellReuseIdentifier: "Cell")
        
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
