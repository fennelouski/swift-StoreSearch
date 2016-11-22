//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Josiah Mory on 11/22/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    
    let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
      if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          if let strongSelf = self {
            strongSelf.image = image
          }
        }
      }
    })
    downloadTask.resume()
    return downloadTask
  }

}
