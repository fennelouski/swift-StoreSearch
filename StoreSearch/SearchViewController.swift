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
  @IBOutlet weak var segmentedControl: UISegmentedControl!

  private var downloadTask: URLSessionDownloadTask?
  private var landscapeViewController: LandscapeViewController?
  
  let search = Search()
  
  struct StandardMarginAndHeights {
    static let topMarginForSearchAndCategoryBar: CGFloat = 108
    static let noMargin: CGFloat = 0
    static let rowHeight: CGFloat = 80
  }
  
  struct TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset = UIEdgeInsets(top: StandardMarginAndHeights.topMarginForSearchAndCategoryBar,
                                          left: StandardMarginAndHeights.noMargin,
                                          bottom: StandardMarginAndHeights.noMargin,
                                          right: StandardMarginAndHeights.noMargin)
    var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
    tableView.rowHeight = StandardMarginAndHeights.rowHeight
    
    cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
    cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
    
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)

    searchBar.becomeFirstResponder()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetail" {
      let detailViewController = segue.destination as! DetailViewController
      let indexPath = sender as! IndexPath
      let searchResult = search.searchResults[indexPath.row]
      detailViewController.searchResult = searchResult
    }
  }
  
  override func willTransition(to newCollection: UITraitCollection,
                               with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    switch newCollection.verticalSizeClass {
    case .compact:
      showLandscape(with: coordinator)
    case .regular, .unspecified:
      hideLandscape(with: coordinator)
    }
  }
  
  @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    performSearch()
  }
  

  
  func showNetworkError() {
    let alert = UIAlertController(
      title: "Whoops...",
      message: "There was an error reading from the iTunes Store. Please try again.",
      preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  
  // MARK: - LandscapeView Functionality
  func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    guard landscapeViewController == nil else { return }
    
    landscapeViewController = storyboard!.instantiateViewController(withIdentifier: "LandscapeViewController")
                                                                                    as? LandscapeViewController
    
    if let controller = landscapeViewController {
      controller.search = search
      controller.view.frame = view.bounds
      controller.view.alpha = 0
      
      view.addSubview(controller.view)
      addChildViewController(controller)
      
      coordinator.animate(alongsideTransition: { _ in
        controller.view.alpha = 1
        self.searchBar.resignFirstResponder()
        if self.presentedViewController != nil {
          self.dismiss(animated: true, completion: nil)
        }
      }, completion: { _ in
        controller.didMove(toParentViewController: self)
      })
    }
  }
  
  func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    if let controller = landscapeViewController {
      controller.willMove(toParentViewController: nil)
      
      coordinator.animate(alongsideTransition: {_ in
        controller.view.alpha = 0
      }, completion: { _ in
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
        self.landscapeViewController = nil
      })
    }
  }
  

  // MARK: - Memory Warning
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }
  
  func performSearch() {
    search.performSearch(for: searchBar.text!,
                         category: segmentedControl.selectedSegmentIndex,
                         completion: { success in
      if !success {
        self.showNetworkError()
      }
      self.tableView.reloadData()
    })
    
    tableView.reloadData()
    searchBar.resignFirstResponder()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if search.isLoading {
     return 1   // Loading...
    } else if !search.hasSearched {
      return 0  // Not searched yet
    } else if search.searchResults.count == 0 {
      return 1  // Nothing found
    } else {
      return search.searchResults.count
    }
  }
 
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {    
    
    if search.isLoading {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell,
                                               for: indexPath)
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if search.searchResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell,
                                           for: indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell,
                                               for: indexPath) as! SearchResultCell

      let searchResult = search.searchResults[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    }
  }
  
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetail", sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if search.searchResults.count == 0 || search.isLoading {
      return nil
    } else {
      return indexPath
    }
  }
}







