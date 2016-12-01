//
//  Search.swift
//  StoreSearch
//
//  Created by Josiah Mory on 12/1/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import Foundation

class Search {
  var searchResults: [SearchResult] = []
  var hasSearched = false
  var isLoading = false
  
  private var dataTask: URLSessionDataTask? = nil
  
  func performSearch(for text: String, category: Int) {
    print("Searching")
  }
}
