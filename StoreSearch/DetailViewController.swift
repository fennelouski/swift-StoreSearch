//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Josiah Mory on 11/22/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class DetailViewController: UIViewController {
  
  private var downloadTask: URLSessionDownloadTask?
  var searchResult: SearchResult! {
    didSet {
      if isViewLoaded {
        updateUI()
      }
    }
  }
  var dismissAnimationStyle = AnimationStyle.fade
  var isPopUp = false
  

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
  
  enum AnimationStyle {
    case slide
    case fade
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

    if isPopUp {
      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
      gestureRecognizer.cancelsTouchesInView = false
      gestureRecognizer.delegate = self
      view.addGestureRecognizer(gestureRecognizer)
      
      if searchResult != nil {
        updateUI()
      }
      
      view.backgroundColor = UIColor.clear
    } else {
      view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
      popupView.isHidden = true

      if let displayName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
        title = displayName
      }
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowMenu" {
      let controller = segue.destination as! MenuViewController
      controller.delegate = self
    }
  }
  
  @IBAction func close(_ sender: Any) {
    dismissAnimationStyle = .slide
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func openInStore() {
    if let url = URL(string: searchResult.storeUrl) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  func updateUI() {
    nameLabel.text = searchResult.name
    
    if searchResult.artistName.isEmpty {
      artistNameLabel.text = NSLocalizedString("Unknown", comment: "Unknown Artist")
    } else {
      artistNameLabel.text = searchResult.artistName
    }
    
    kindValue.text = searchResult.kindForDisplay()
    genreValue.text = searchResult.genre
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency
    
    let priceText: String
    if searchResult.price == 0 {
      priceText = NSLocalizedString("Free", comment: "Price: Free")
    } else if let text = formatter.string(from: searchResult.price as NSNumber) {
      priceText = text
    } else {
      priceText = ""
    }
    
    priceButton.setTitle(priceText, for: .normal)
    
    if let largeUrl = URL(string: searchResult.artworkLargeUrl) {
      downloadTask = artworkImageView.loadImage(url: largeUrl)
    }
    
    UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: { _ in
        self.popupView.isHidden = false
    }, completion: { _ in })

  }
  
  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
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
  
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BounceAnimationController()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch dismissAnimationStyle {
    case .slide:
      return SlideOutAnimationController()
    case .fade:
      return FadeOutAnimationController()
    }
  }
}

extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

    return(touch.view === self.view)
  }
}

extension DetailViewController: MenuViewControllerDelegate {
  func menuViewControllerSendSupportEmail(_ controller: MenuViewController) {
    dismiss(animated: true) {
      if MFMailComposeViewController.canSendMail() {
        let controller = MFMailComposeViewController()
        controller.setSubject(NSLocalizedString("Support Request",
                                                comment: "Email subject"))
        controller.setToRecipients(["josiah@kickinbahkproductions.com"])
        controller.modalPresentationStyle = .formSheet
        controller.mailComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
      }
    }
  }
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    dismiss(animated: true, completion: nil)
  }
}









