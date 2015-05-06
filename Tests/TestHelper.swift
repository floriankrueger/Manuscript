//
//  TestHelper.swift
//  Manuscript
//
//  Created by Florian Krüger on 06/05/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//

import Foundation
import UIKit
import XCTest

struct Helper {
  static func checkConstraint(
    constraint: NSLayoutConstraint,
    item: UIView,
    attribute: NSLayoutAttribute,
    relation: NSLayoutRelation,
    relatedItem: UIView? = nil,
    relatedAttribute: NSLayoutAttribute = .NotAnAttribute,
    multiplier: Float = 1.0,
    constant: Float)
  {
    XCTAssertNotNil(constraint, "constraint must not be nil")
    XCTAssertEqual(constraint.firstItem as! UIView, item,                 "")
    XCTAssertEqual(constraint.firstAttribute,       attribute,            "")
    XCTAssertEqual(constraint.relation,             relation,             "")

    if let strongRelatedItem = relatedItem {
      XCTAssertEqual(constraint.secondItem as! UIView, strongRelatedItem, "")
    } else {
      XCTAssertNil(constraint.secondItem,                                 "")
    }

    XCTAssertEqual(constraint.secondAttribute,      relatedAttribute,     "")
    XCTAssertEqual(constraint.multiplier,           CGFloat(multiplier),  "")
    XCTAssertEqual(constraint.constant,             CGFloat(constant),    "")
  }

  static func randomFloat(min: Float = 0.0, max: Float) -> Float {
    let random = Float(arc4random()) / Float(UInt32.max)
    return random * (max - min) + min
  }

  static func firstConstraint(view: UIView, withAttribute optionalAttribute: NSLayoutAttribute? = nil) -> NSLayoutConstraint? {
    if view.constraints().count > 0 {
      for object in view.constraints() {
        if let constraint = object as? NSLayoutConstraint {
          if let attribute = optionalAttribute {
            if constraint.firstAttribute == attribute {
              return constraint
            }
          } else {
            return constraint
          }
        }
      }
    }
    return nil
  }
}

extension NSLayoutAttribute : Printable {
  public var description: String {
    switch self {
    case .Left:
      return "Left"
    case .Right:
      return "Right"
    case .Top:
      return "Top"
    case .Bottom:
      return "Bottom"
    case .Leading:
      return "Leading"
    case .Trailing:
      return "Trailing"
    case .Width:
      return "Width"
    case .Height:
      return "Height"
    case .CenterX:
      return "CenterX"
    case .CenterY:
      return "CenterY"
    case .Baseline:
      return "Baseline"
    case .FirstBaseline:
      return "FirstBaseline"
    case .LeftMargin:
      return "LeftMargin"
    case .RightMargin:
      return "RightMargin"
    case .TopMargin:
      return "TopMargin"
    case .BottomMargin:
      return "BottomMargin"
    case .LeadingMargin:
      return "LeadingMargin"
    case .TrailingMargin:
      return "TrailingMargin"
    case .CenterXWithinMargins:
      return "CenterXWithinMargins"
    case .CenterYWithinMargins:
      return "CenterYWithinMargins"
    case .NotAnAttribute:
      return "NotAnAttribute"
    }
  }
}
