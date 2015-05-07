//
//  UIViewExtension.swift
//  Manuscript
//
//  Created by Florian Krüger on 26/04/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIView {

  var manuscript_constraints: [String:NSLayoutConstraint]? {
    get {
      return objc_getAssociatedObject(self, &Manuscript.associatedObject) as? [String:NSLayoutConstraint]
    }

    set {
      if let value = newValue {
        objc_setAssociatedObject(self, value, &Manuscript.associatedObject, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      }
    }
  }
}
