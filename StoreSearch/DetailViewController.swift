//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Josiah Mory on 11/22/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

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
