//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Josiah Mory on 11/22/16.
//  Copyright © 2016 kickinbahk Productions. All rights reserved.
//

import Foundation
import UIKit

class DimmingPresentationController: UIPresentationController {
  override var shouldRemovePresentersView: Bool {
    return false
  }
  
  lazy var dimmingView = GradientView(frame: CGRect.zero)
  
  override func presentationTransitionWillBegin() {
    dimmingView.frame = containerView!.bounds
    containerView!.insertSubview(dimmingView, at: 0)
  }
}
