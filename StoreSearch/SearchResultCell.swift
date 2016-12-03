//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Josiah Mory on 11/1/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import UIKit
import Foundation

class SearchResultCell: UITableViewCell {
  
  private var downloadTask: URLSessionDownloadTask?

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!

  override func awakeFromNib() {
      super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    
    selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
    selectedBackgroundView = selectedView
    
    nameLabel.adjustsFontForContentSizeCategory = true
    artistNameLabel.adjustsFontForContentSizeCategory = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()

    downloadTask?.cancel()
    downloadTask = nil
  }
  
  func configure(for searchResult: SearchResult) {
    nameLabel.text = searchResult.name
    
    if searchResult.artistName.isEmpty {
      artistNameLabel.text = NSLocalizedString("Unknown", comment: "Unknown Artist")
    } else {
      artistNameLabel.text = String(format: NSLocalizedString("ARTIST_NAME_LABEL_FORMAT",
                                                              comment: "Format for artist name label"),
                                    searchResult.artistName, searchResult.kindForDisplay())
    }
    
    artworkImageView.image = UIImage(named: "Placeholder")
    if let smallUrl = URL(string: searchResult.artworkSmallUrl) {
      downloadTask = artworkImageView.loadImage(url: smallUrl)
    }
  }
}







