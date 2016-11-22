//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Josiah Mory on 11/22/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
  }
}
