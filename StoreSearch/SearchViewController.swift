//
//  SearchViewController.swift
//  StoreSearch
//
//  Created by Josiah Mory on 10/31/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  var searchResults: [SearchResult] = []
  var hasSearched = false
  
  struct StandardMarginAndHeights {
    static let topMarginForSearchBar: CGFloat = 64
    static let noMargin: CGFloat = 0
    static let rowHeight: CGFloat = 80
  }
  
  struct TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset = UIEdgeInsets(top: StandardMarginAndHeights.topMarginForSearchBar,
                                          left: StandardMarginAndHeights.noMargin,
                                          bottom: StandardMarginAndHeights.noMargin,
                                          right: StandardMarginAndHeights.noMargin)
    var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
    tableView.rowHeight = StandardMarginAndHeights.rowHeight
    
    cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
    
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    searchBar.becomeFirstResponder()
  }
  
  func iTunesUrl(searchText: String) -> URL {
    let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = String(format: "https://itunes.apple.com/search?term=%@", escapedSearchText)
    let url = URL(string: urlString)
    return url!
  }


  
  // Mark: - Memory Warning
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      
      searchResults = []
      hasSearched = true
      
      let url = iTunesUrl(searchText: searchBar.text!)
      print("URL: '\(url)'")
      
      tableView.reloadData()
    }

  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
 
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {    
    if searchResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell,
                                           for: indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell,
                                               for: indexPath) as! SearchResultCell
      let searchResult = searchResults[indexPath.row]
      
      cell.nameLabel.text = searchResult.name
      cell.artistNameLabel.text = searchResult.artistName
      return cell
    }
  }
  
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if searchResults.count == 0 {
      return nil
    } else {
      return indexPath
    }
  }
}







