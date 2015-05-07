//
//  TestHelper.swift
//  Manuscript
//
//  Created by Florian Krüger on 06/05/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
