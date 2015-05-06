//
//  ConvenienceTests.swift
//  Manuscript
//
//  Created by Florian Krüger on 06/05/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//

import UIKit
import XCTest
import Manuscript

class ConvenienceTests: XCTestCase {

  func testAlignAllEdges() {
    let parentView = UIView(frame: CGRectZero)
    let childView = UIView(frame: CGRectZero)
    parentView.addSubview(childView)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.layout(childView) { c in
      c.alignAllEdges(to: parentView)
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      for attribute in [NSLayoutAttribute.Left, NSLayoutAttribute.Right, NSLayoutAttribute.Top, NSLayoutAttribute.Bottom] {
        if let constraint = Helper.firstConstraint(parentView, withAttribute:attribute) {
          Helper.checkConstraint(constraint, item:childView, attribute:attribute, relation:.Equal, relatedItem:parentView, relatedAttribute:attribute, constant:0.0)
        } else {
          XCTFail("view is expected to have one constraint for \(attribute)")
        }
      }
      XCTAssertEqual(4, parentView.constraints().count, "parentView is expected to have four constraint")
      XCTAssertEqual(0, childView.constraints().count, "childView is expected to have no constraint")
      XCTAssertNil(error, "")
    }
  }

}
