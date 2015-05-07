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

  func testAlignAllEdgesWithInsets() {
    let parentView = UIView(frame: CGRectZero)
    let childView = UIView(frame: CGRectZero)
    parentView.addSubview(childView)
    let attributes = [NSLayoutAttribute.Left, NSLayoutAttribute.Right, NSLayoutAttribute.Top, NSLayoutAttribute.Bottom]
    let insets = UIEdgeInsets(top: 1.0, left: 2.0, bottom: 3.0, right: 4.0)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.layout(childView) { c in
      c.alignAllEdges(to: parentView, withInsets: insets)
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      for attribute in [NSLayoutAttribute.Left, NSLayoutAttribute.Right, NSLayoutAttribute.Top, NSLayoutAttribute.Bottom] {
        if let constraint = Helper.firstConstraint(parentView, withAttribute:attribute) {
          let constant: Float
          switch attribute {
          case .Left:
            constant = Float(insets.left)
          case .Right:
            constant = -1 * Float(insets.right)
          case .Top:
            constant = Float(insets.top)
          case .Bottom:
            constant = -1 * Float(insets.bottom)
          default:
            constant = 0.0
          }
          Helper.checkConstraint(constraint, item:childView, attribute:attribute, relation:.Equal, relatedItem:parentView, relatedAttribute:attribute, constant:constant)
        } else {
          XCTFail("view is expected to have one constraint for \(attribute)")
        }
      }
      XCTAssertEqual(4, parentView.constraints().count, "parentView is expected to have four constraint")
      XCTAssertEqual(0, childView.constraints().count, "childView is expected to have no constraint")
      XCTAssertNil(error, "")
    }
  }

  func testCenterIn() {
    let parentView = UIView(frame: CGRectZero)
    let childView = UIView(frame: CGRectZero)
    parentView.addSubview(childView)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.layout(childView) { c in
      c.centerIn(parentView)
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      for attribute in [NSLayoutAttribute.CenterX, NSLayoutAttribute.CenterY] {
        if let constraint = Helper.firstConstraint(parentView, withAttribute:attribute) {
          Helper.checkConstraint(constraint, item:childView, attribute:attribute, relation:.Equal, relatedItem:parentView, relatedAttribute:attribute, constant:0.0)
        } else {
          XCTFail("view is expected to have one constraint for \(attribute)")
        }
      }
      XCTAssertEqual(2, parentView.constraints().count, "parentView is expected to have four constraint")
      XCTAssertEqual(0, childView.constraints().count, "childView is expected to have no constraint")
      XCTAssertNil(error, "")
    }
  }

}
