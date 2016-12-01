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
  
  private func iTunesUrl(searchText: String, category: Int) -> URL {
    let entityName: String
    
    switch category {
    case 1: entityName = "musicTrack"
    case 2: entityName = "software"
    case 3: entityName = "ebook"
    default: entityName = ""
    }
    
    let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=%@",
                           escapedSearchText, entityName)
    let url = URL(string: urlString)
    return url!
  }
  
  private func parse(json data: Data) -> [String: Any]? {
    do {
      return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
      print("JSON Error: '\(error)'")
      return nil
    }
  }
  
  private func parse(dictionary: [String: Any]) -> [SearchResult] {
    guard let array = dictionary["results"] as? [Any] else {
      print("Expected 'results' array")
      return []
    }
    
    var searchResults: [SearchResult] = []
    
    for resultDict in array {
      if let resultDict = resultDict as? [String: Any] {
        var searchResult: SearchResult?
        
        if let wrapperType = resultDict["wrapperType"] as? String {
          switch wrapperType {
          case "track":
            searchResult = parse(track: resultDict)
          case "audiobook":
            searchResult = parse(audiobook: resultDict)
          case "software":
            searchResult = parse(software: resultDict)
          default:
            break
          }
        } else if let kind = resultDict["kind"] as? String, kind == "ebook" {
          searchResult = parse(ebook: resultDict)
        }
        
        if let result = searchResult {
          searchResults.append(result)
        }
      }
    }
    
    return searchResults
  }
  
  private func parse(track dictionary: [String: Any]) -> SearchResult {
    let searchResult = SearchResult()
    
    searchResult.name = dictionary["trackName"] as! String
    searchResult.artistName = dictionary["artistName"] as! String
    searchResult.artworkSmallUrl = dictionary["artworkUrl60"] as! String
    searchResult.artworkLargeUrl = dictionary["artworkUrl100"] as! String
    searchResult.storeUrl = dictionary["trackViewUrl"] as! String
    searchResult.kind = dictionary["kind"] as! String
    searchResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["trackPrice"] as? Double {
      searchResult.price = price
    }
    
    if let genre = dictionary["primaryGenreName"] as? String {
      searchResult.genre = genre
    }
    return searchResult
  }
  
  private func parse(audiobook dictionary: [String: Any]) -> SearchResult {
    let searchResult = SearchResult()
    searchResult.name = dictionary["collectionName"] as! String
    searchResult.artistName = dictionary["artistName"] as! String
    searchResult.artworkSmallUrl = dictionary["artworkUrl60"] as! String
    searchResult.artworkLargeUrl = dictionary["artworkUrl100"] as! String
    searchResult.storeUrl = dictionary["collectionViewUrl"] as! String
    searchResult.kind = "audiobook"
    searchResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["collectionPrice"] as? Double {
      searchResult.price = price
    }
    if let genre = dictionary["primaryGenreName"] as? String {
      searchResult.genre = genre
    }
    return searchResult
  }
  
  private func parse(software dictionary: [String: Any]) -> SearchResult {
    let searchResult = SearchResult()
    searchResult.name = dictionary["trackName"] as! String
    searchResult.artistName = dictionary["artistName"] as! String
    searchResult.artworkSmallUrl = dictionary["artworkUrl60"] as! String
    searchResult.artworkLargeUrl = dictionary["artworkUrl100"] as! String
    searchResult.storeUrl = dictionary["trackViewUrl"] as! String
    searchResult.kind = dictionary["kind"] as! String
    searchResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["price"] as? Double {
      searchResult.price = price
    }
    if let genre = dictionary["primaryGenreName"] as? String {
      searchResult.genre = genre
    }
    return searchResult
  }
  
  private func parse(ebook dictionary: [String: Any]) -> SearchResult {
    let searchResult = SearchResult()
    searchResult.name = dictionary["trackName"] as! String
    searchResult.artistName = dictionary["artistName"] as! String
    searchResult.artworkSmallUrl = dictionary["artworkUrl60"] as! String
    searchResult.artworkLargeUrl = dictionary["artworkUrl100"] as! String
    searchResult.storeUrl = dictionary["trackViewUrl"] as! String
    searchResult.kind = dictionary["kind"] as! String
    searchResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["price"] as? Double {
      searchResult.price = price
    }
    if let genres: Any = dictionary["genres"] as? String {
      searchResult.genre = (genres as! [String]).joined(separator: ", ")
    }
    return searchResult
  }
}
