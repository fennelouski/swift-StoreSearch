//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Josiah Mory on 11/22/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  var searchResult: SearchResult!

  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindValue: UILabel!
  @IBOutlet weak var genreValue: UILabel!
  @IBOutlet weak var priceButton: UIButton!
  
  struct detailTintColor {
    static let redness: CGFloat = 20/255
    static let greeness: CGFloat = 160/255
    static let blueness: CGFloat = 160/255
    static let opacity: CGFloat = 1
  }
  
  struct detailDisplayProps {
    static let roundedCorners: CGFloat = 10
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      view.tintColor = UIColor(red: detailTintColor.redness,
                               green: detailTintColor.greeness,
                               blue: detailTintColor.blueness,
                               alpha: detailTintColor.opacity)
      popupView.layer.cornerRadius = detailDisplayProps.roundedCorners
      let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                     action: #selector(close))
      gestureRecognizer.cancelsTouchesInView = false
      gestureRecognizer.delegate = self
      view.addGestureRecognizer(gestureRecognizer)
      if searchResult != nil {
        updateUI()
      }
    }
  
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func updateUI() {
    nameLabel.text = searchResult.name
    
    if searchResult.artistName.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = searchResult.artistName
    }
    
    kindValue.text = searchResult.kind
    genreValue.text = searchResult.genre
  }

  // MARK: - Memory Warning
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

extension DetailViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?,
                              source: UIViewController) -> UIPresentationController? {
    
    return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
  }
}

extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

    return(touch.view === self.view)
  }
}











