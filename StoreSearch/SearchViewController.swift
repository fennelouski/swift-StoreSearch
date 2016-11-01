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
  
  var searchResults: [String] = []
  
  let topMarginForSearchBar: CGFloat = 64
  let noMargin: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset = UIEdgeInsets(top: topMarginForSearchBar,
                                          left: noMargin,
                                          bottom: noMargin,
                                          right: noMargin)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchResults = []
    
    searchBar.resignFirstResponder()
    
    for i in 0...2 {
      searchResults.append(String(format: "Fake Result %d for '%@'", i, searchBar.text!))
    }
    
    tableView.reloadData()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }
 
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "SearchResultCell"
    
    var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
    
    cell.textLabel!.text = searchResults[indexPath.row]
    return cell
  }
  
}

extension SearchViewController: UITableViewDelegate {
}







