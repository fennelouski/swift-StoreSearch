//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Josiah Mory on 12/4/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
  func menuViewControllerSendSupportEmail(_ controller: MenuViewController)
}

class MenuViewController: UITableViewController {
  
  weak var delegate: MenuViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }

  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.row == 0 {
      delegate?.menuViewControllerSendSupportEmail(self)
    }
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }



}
