//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Josiah Mory on 11/28/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {
  
  private var firstTime = true
  var searchResults = [SearchResult]()

  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    


    view.removeConstraints(view.constraints)
    view.translatesAutoresizingMaskIntoConstraints = true
    
    pageControl.removeConstraints(pageControl.constraints)
    pageControl.translatesAutoresizingMaskIntoConstraints = true
    
    scrollView.removeConstraints(scrollView.constraints)
    scrollView.translatesAutoresizingMaskIntoConstraints = true
    
    scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)

  }
  
  override func viewWillLayoutSubviews() {
   super.viewWillLayoutSubviews()
    
    scrollView.frame = view.bounds
    
    pageControl.frame = CGRect(x: 0,
                               y: view.frame.size.height - pageControl.frame.size.height,
                               width: view.frame.size.width,
                               height: pageControl.frame.size.height)
  }

  
  deinit {
    print("deinit \(self)")
  }

  
  // MARK: - Memory Warning
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
