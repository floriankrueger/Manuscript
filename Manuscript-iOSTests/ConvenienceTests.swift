//
//  ConvenienceTests.swift
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
      XCTAssertEqual(4, parentView.constraints.count, "parentView is expected to have four constraints")
      XCTAssertEqual(0, childView.constraints.count, "childView is expected to have no constraint")
      XCTAssertNil(error, "")
    }
  }

  func testAlignAllEdgesWithInsets() {
    let parentView = UIView(frame: CGRectZero)
    let childView = UIView(frame: CGRectZero)
    parentView.addSubview(childView)
    let insets = UIEdgeInsets(top: 1.0, left: 2.0, bottom: 3.0, right: 4.0)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.layout(childView) { c in
      c.alignAllEdges(to: parentView, withInsets: insets)
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      for attribute in [NSLayoutAttribute.Left, NSLayoutAttribute.Right, NSLayoutAttribute.Top, NSLayoutAttribute.Bottom] {
        if let constraint = Helper.firstConstraint(parentView, withAttribute:attribute) {
          let constant: CGFloat
          switch attribute {
          case .Left:
            constant = insets.left
          case .Right:
            constant = -1 * insets.right
          case .Top:
            constant = insets.top
          case .Bottom:
            constant = -1 * insets.bottom
          default:
            constant = 0.0
          }
          Helper.checkConstraint(constraint, item:childView, attribute:attribute, relation:.Equal, relatedItem:parentView, relatedAttribute:attribute, constant:constant)
        } else {
          XCTFail("view is expected to have one constraint for \(attribute)")
        }
      }
      XCTAssertEqual(4, parentView.constraints.count, "parentView is expected to have four constraints")
      XCTAssertEqual(0, childView.constraints.count, "childView is expected to have no constraint")
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
      XCTAssertEqual(2, parentView.constraints.count, "parentView is expected to have two constraints")
      XCTAssertEqual(0, childView.constraints.count, "childView is expected to have no constraint")
      XCTAssertNil(error, "")
    }
  }

  func testSetSize() {
    let view = UIView(frame: CGRectZero)
    let width:CGFloat = 100.0
    let height:CGFloat = 200.0
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.layout(view) { c in
      c.setSize(CGSize(width: width, height: height))
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      for attribute in [NSLayoutAttribute.Width, NSLayoutAttribute.Height] {
        if let constraint = Helper.firstConstraint(view, withAttribute:attribute) {
          let constant: CGFloat
          switch attribute {
          case .Width:
            constant = width
          case .Height:
            constant = height
          default:
            constant = 0.0
          }
          Helper.checkConstraint(constraint, item:view, attribute:attribute, relation:.Equal, constant:constant)
        } else {
          XCTFail("view is expected to have one constraint for \(attribute)")
        }
        XCTAssertEqual(2, view.constraints.count, "view is expected to have two constraints")
        XCTAssertNil(error, "")
      }
    }
  }

  func testHorizontalHairlineOnRetina() {
    let view = UIView(frame: CGRectZero)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.makeLayout(utils: RetinaUtils())(view) { c in
      c.makeHorizontalHairline()
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      if let constraint = Helper.firstConstraint(view, withAttribute:.Height) {
        Helper.checkConstraint(constraint, item:view, attribute:.Height, relation:.Equal, constant:0.5)
      } else {
        XCTFail("view is expected to have one constraint for \(NSLayoutAttribute.Height)")
      }
      XCTAssertEqual(1, view.constraints.count, "view is expected to have one constraint")
      XCTAssertNil(error, "")
    }
  }

  func testHorizontalHairlineOnNonRetina() {
    let view = UIView(frame: CGRectZero)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.makeLayout(utils: NonRetinaUtils())(view) { c in
      c.makeHorizontalHairline()
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      if let constraint = Helper.firstConstraint(view, withAttribute:.Height) {
        Helper.checkConstraint(constraint, item:view, attribute:.Height, relation:.Equal, constant:1.0)
      } else {
        XCTFail("view is expected to have one constraint for \(NSLayoutAttribute.Height)")
      }
      XCTAssertEqual(1, view.constraints.count, "view is expected to have one constraint")
      XCTAssertNil(error, "")
    }
  }

  func testVerticalHairlineOnRetina() {
    let view = UIView(frame: CGRectZero)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.makeLayout(utils: RetinaUtils())(view) { c in
      c.makeVerticalHairline()
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      if let constraint = Helper.firstConstraint(view, withAttribute:.Width) {
        Helper.checkConstraint(constraint, item:view, attribute:.Width, relation:.Equal, constant:0.5)
      } else {
        XCTFail("view is expected to have one constraint for \(NSLayoutAttribute.Width)")
      }
      XCTAssertEqual(1, view.constraints.count, "view is expected to have one constraint")
      XCTAssertNil(error, "")
    }
  }

  func testVerticalHairlineOnNonRetina() {
    let view = UIView(frame: CGRectZero)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.makeLayout(utils: NonRetinaUtils())(view) { c in
      c.makeVerticalHairline()
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      if let constraint = Helper.firstConstraint(view, withAttribute:.Width) {
        Helper.checkConstraint(constraint, item:view, attribute:.Width, relation:.Equal, constant:1.0)
      } else {
        XCTFail("view is expected to have one constraint for \(NSLayoutAttribute.Width)")
      }
      XCTAssertEqual(1, view.constraints.count, "view is expected to have one constraint")
      XCTAssertNil(error, "")
    }
  }

  // MARK: - Mocks

  struct RetinaUtils: ManuscriptUtils {
    func isRetina() -> Bool {
      return true
    }
  }

  struct NonRetinaUtils: ManuscriptUtils {
    func isRetina() -> Bool {
      return false
    }
  }

}
