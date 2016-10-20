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
    _ constraint: NSLayoutConstraint,
    item: UIView,
    attribute: NSLayoutAttribute,
    relation: NSLayoutRelation,
    relatedItem: UIView? = nil,
    relatedAttribute: NSLayoutAttribute = .notAnAttribute,
    multiplier: CGFloat = 1.0,
    constant: CGFloat)
  {
    XCTAssertNotNil(constraint, "constraint must not be nil")
    XCTAssertEqual(constraint.firstItem as? UIView, item, "")
    XCTAssertEqual(constraint.firstAttribute, attribute, "")
    XCTAssertEqual(constraint.relation, relation, "")

    if let strongRelatedItem = relatedItem {
      XCTAssertEqual(constraint.secondItem as? UIView, strongRelatedItem, "")
    } else {
      XCTAssertNil(constraint.secondItem, "")
    }

    XCTAssertEqual(constraint.secondAttribute, relatedAttribute, "")
    XCTAssertEqualWithAccuracy(constraint.multiplier, multiplier, accuracy: CGFloat(FLT_EPSILON), "")
    XCTAssertEqual(constraint.constant, constant, "")
  }

  static func randomFloat(_ min: CGFloat = 0.0, max: CGFloat) -> CGFloat {
    let random = CGFloat(arc4random()) / CGFloat(UInt32.max)
    return random * (max - min) + min
  }

  static func firstConstraint(_ view: UIView, withAttribute optionalAttribute: NSLayoutAttribute? = nil) -> NSLayoutConstraint? {
    if view.constraints.count > 0 {
      for constraint in view.constraints {
        if let attribute = optionalAttribute {
          if constraint.firstAttribute == attribute {
            return constraint
          }
        } else {
          return constraint
        }
      }
    }
    return nil
  }
}

extension NSLayoutAttribute : CustomStringConvertible {
  public var description: String {
    switch self {
    case .left:
      return "Left"
    case .right:
      return "Right"
    case .top:
      return "Top"
    case .bottom:
      return "Bottom"
    case .leading:
      return "Leading"
    case .trailing:
      return "Trailing"
    case .width:
      return "Width"
    case .height:
      return "Height"
    case .centerX:
      return "CenterX"
    case .centerY:
      return "CenterY"
    case .lastBaseline:
      return "Baseline"
    case .firstBaseline:
      return "FirstBaseline"
    case .leftMargin:
      return "LeftMargin"
    case .rightMargin:
      return "RightMargin"
    case .topMargin:
      return "TopMargin"
    case .bottomMargin:
      return "BottomMargin"
    case .leadingMargin:
      return "LeadingMargin"
    case .trailingMargin:
      return "TrailingMargin"
    case .centerXWithinMargins:
      return "CenterXWithinMargins"
    case .centerYWithinMargins:
      return "CenterYWithinMargins"
    case .notAnAttribute:
      return "NotAnAttribute"
    }
  }
}
