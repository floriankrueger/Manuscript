//
//  LayoutTests.swift
//  Manuscript
//
//  Created by Florian Krüger on 06/05/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//

import UIKit
import XCTest
import Manuscript

class LayoutTests: XCTestCase {

  private let setAttributes: [NSLayoutAttribute] = [.Width, .Height]

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  // MARK: - Helper

  func checkConstraint(constraint: NSLayoutConstraint, item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedItem: UIView? = nil, relatedAttribute: NSLayoutAttribute = .NotAnAttribute, multiplier: Float = 1.0, constant: Float) {
    XCTAssertNotNil(constraint, "constraint must not be nil")
    XCTAssertEqual(constraint.firstItem as! UIView, item,                 "")
    XCTAssertEqual(constraint.firstAttribute,       attribute,            "")
    XCTAssertEqual(constraint.relation,             .Equal,               "")

    if let strongRelatedItem = relatedItem {
      XCTAssertEqual(constraint.secondItem as! UIView, strongRelatedItem, "")
    } else {
      XCTAssertNil(constraint.secondItem,                                 "")
    }

    XCTAssertEqual(constraint.secondAttribute,      relatedAttribute,     "")
    XCTAssertEqual(constraint.multiplier,           CGFloat(multiplier),  "")
    XCTAssertEqual(constraint.constant,             CGFloat(constant),    "")
  }

  func randomFloat(min: Float = 0.0, max: Float) -> Float {
    let random = Float(arc4random()) / Float(UInt32.max)
    return random * (max - min) + min
  }

  func firstConstraint(view: UIView, withAttribute optionalAttribute: NSLayoutAttribute? = nil) -> NSLayoutConstraint? {
    if view.constraints().count > 0 {
      if let constraint = view.constraints().first as? NSLayoutConstraint {
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

  // MARK: - Tests

  func testSet() {
    for attribute in self.setAttributes {
      let constant = self.randomFloat(max: 100.0)
      let view = UIView(frame: CGRectZero)
      let expectation = self.expectationWithDescription("constraints installed")

      Manuscript.layout(view) { c in
        c.set(attribute, to:constant)
        expectation.fulfill()
      }

      self.waitForExpectationsWithTimeout(0.1) { error in
        if let constraint = self.firstConstraint(view) {
          self.checkConstraint(constraint, item:view, attribute:attribute, relation:.Equal, constant:constant)
        } else {
          XCTFail("view is expected to have at least one constraint")
        }
        XCTAssertEqual(1, view.constraints().count, "view is expected to have one constraint only")
        XCTAssertNil(error, "")
      }
    }
  }

}
