//
//  LayoutTests.swift
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

class LayoutTests: XCTestCase {

  // MARK: - Tests: SET/EQUAL

  func meta_testSet(attribute: NSLayoutAttribute, relation: NSLayoutRelation = .Equal) {
    let constant = Helper.randomFloat(max: 100.0)
    let view = UIView(frame: CGRectZero)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.layout(view) { c in
      switch relation {
      case .LessThanOrEqual:
        c.set(attribute, toLessThan:constant)
      case .Equal:
        c.set(attribute, to:constant)
      case .GreaterThanOrEqual:
        c.set(attribute, toMoreThan:constant)
      }

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      if let constraint = Helper.firstConstraint(view) {
        Helper.checkConstraint(constraint, item:view, attribute:attribute, relation:relation, constant:constant)
      } else {
        XCTFail("view is expected to have at least one constraint")
      }
      XCTAssertEqual(1, view.constraints.count, "view is expected to have one constraint only")
      XCTAssertNil(error, "")
    }
  }

  func testSetWidth() {
    meta_testSet(.Width)
  }

  func testSetHeight() {
    meta_testSet(.Height)
  }

  func testSetGreaterThanWidth() {
    meta_testSet(.Width, relation:.GreaterThanOrEqual)
  }

  func testSetGreaterThanHeight() {
    meta_testSet(.Height, relation:.GreaterThanOrEqual)
  }

  func testSetLessThanWidth() {
    meta_testSet(.Width, relation:.LessThanOrEqual)
  }

  func testSetLessThanHeight() {
    meta_testSet(.Height, relation:.LessThanOrEqual)
  }

  // MARK: - Tests: MAKE/EQUAL

  func meta_testMake(attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedAttribute: NSLayoutAttribute, useTargetView: Bool) {
    let constant = Helper.randomFloat(max: 100.0)
    let multiplier = Helper.randomFloat(max: 2.0)
    let parentView = UIView(frame: CGRectZero)
    let childView = UIView(frame: CGRectZero)
    parentView.addSubview(childView)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.layout(childView) { c in
      
      switch (relation, useTargetView) {
      case (.Equal, true):
        c.make(attribute, equalTo:parentView, s:relatedAttribute, times:multiplier, plus:constant, on:parentView)
      case (.Equal, false):
        c.make(attribute, equalTo:parentView, s:relatedAttribute, times:multiplier, plus:constant)
      case (.GreaterThanOrEqual, true):
        c.make(attribute, greaterThan:parentView, s:relatedAttribute, times:multiplier, plus:constant, on:parentView)
      case (.GreaterThanOrEqual, false):
        c.make(attribute, greaterThan:parentView, s:relatedAttribute, times:multiplier, plus:constant)
      case (.LessThanOrEqual, true):
        c.make(attribute, lessThan:parentView, s:relatedAttribute, times:multiplier, plus:constant, on:parentView)
      case (.LessThanOrEqual, false):
        c.make(attribute, lessThan:parentView, s:relatedAttribute, times:multiplier, plus:constant)
      }
      
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      if let constraint = Helper.firstConstraint(parentView, withAttribute:attribute) {
        Helper.checkConstraint(constraint, item:childView, attribute:attribute, relation:relation, relatedItem:parentView, relatedAttribute:relatedAttribute, multiplier:multiplier, constant:constant)
      } else {
        XCTFail("parentView is expected to have at least one constraint for attribute \(attribute)")
      }
      XCTAssertEqual(1, parentView.constraints.count, "parentView is expected to have one constraint only")
      XCTAssertEqual(0, childView.constraints.count, "childView is expected to have no constraint")
      XCTAssertNil(error, "")
    }
  }

  func testMakeWidthEqualWidth() {
    meta_testMake(.Width, relation:.Equal, relatedAttribute:.Width, useTargetView:false)
  }

  func testMakeWidthEqualWidthOnTargetView() {
    meta_testMake(.Width, relation:.Equal, relatedAttribute:.Width, useTargetView:true)
  }

  func testMakeWidthEqualHeight() {
    meta_testMake(.Width, relation:.Equal, relatedAttribute:.Height, useTargetView:false)
  }

  func testMakeWidthEqualHeightOnTargetView() {
    meta_testMake(.Width, relation:.Equal, relatedAttribute:.Height, useTargetView:true)
  }

  func testMakeLeftEqualLeft() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeLeftEqualLeftOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeLeftEqualRight() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeLeftEqualRightOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeLeftEqualTop() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeLeftEqualTopOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeLeftEqualBottom() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeLeftEqualBottomOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeLeftEqualCenterX() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeLeftEqualCenterXOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeLeftEqualCenterY() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeLeftEqualCenterYOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeLeftEqualBaseline() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeLeftEqualBaselineOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeRightEqualLeft() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeRightEqualLeftOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeRightEqualRight() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeRightEqualRightOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeRightEqualTop() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeRightEqualTopOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeRightEqualBottom() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeRightEqualBottomOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeRightEqualCenterX() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeRightEqualCenterXOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeRightEqualCenterY() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeRightEqualCenterYOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeRightEqualBaseline() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeRightEqualBaselineOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeTopEqualLeft() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeTopEqualLeftOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeTopEqualRight() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeTopEqualRightOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeTopEqualTop() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeTopEqualTopOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeTopEqualBottom() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeTopEqualBottomOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeTopEqualLeading() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeTopEqualLeadingOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeTopEqualTrailing() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeTopEqualTrailingOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeTopEqualCenterX() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeTopEqualCenterXOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeTopEqualCenterY() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeTopEqualCenterYOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeTopEqualBaseline() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeTopEqualBaselineOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeBottomEqualLeft() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeBottomEqualLeftOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeBottomEqualRight() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeBottomEqualRightOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeBottomEqualTop() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeBottomEqualTopOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeBottomEqualBottom() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeBottomEqualBottomOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeBottomEqualLeading() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeBottomEqualLeadingOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeBottomEqualTrailing() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeBottomEqualTrailingOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeBottomEqualCenterX() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeBottomEqualCenterXOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeBottomEqualCenterY() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeBottomEqualCenterYOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeBottomEqualBaseline() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeBottomEqualBaselineOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeLeadingEqualTop() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeLeadingEqualTopOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeLeadingEqualBottom() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeLeadingEqualBottomOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeLeadingEqualLeading() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeLeadingEqualLeadingOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeLeadingEqualTrailing() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeLeadingEqualTrailingOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeLeadingEqualCenterX() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeLeadingEqualCenterXOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeLeadingEqualCenterY() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeLeadingEqualCenterYOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeLeadingEqualBaseline() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeLeadingEqualBaselineOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeTrailingEqualTop() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeTrailingEqualTopOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeTrailingEqualBottom() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeTrailingEqualBottomOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeTrailingEqualLeading() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeTrailingEqualLeadingOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeTrailingEqualTrailing() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeTrailingEqualTrailingOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeTrailingEqualCenterX() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeTrailingEqualCenterXOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeTrailingEqualCenterY() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeTrailingEqualCenterYOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeTrailingEqualBaseline() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeTrailingEqualBaselineOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeHeightEqualWidth() {
    meta_testMake(.Height, relation:.Equal, relatedAttribute:.Width, useTargetView:false)
  }

  func testMakeHeightEqualWidthOnTargetView() {
    meta_testMake(.Height, relation:.Equal, relatedAttribute:.Width, useTargetView:true)
  }

  func testMakeHeightEqualHeight() {
    meta_testMake(.Height, relation:.Equal, relatedAttribute:.Height, useTargetView:false)
  }

  func testMakeHeightEqualHeightOnTargetView() {
    meta_testMake(.Height, relation:.Equal, relatedAttribute:.Height, useTargetView:true)
  }

  func testMakeCenterXEqualLeft() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeCenterXEqualLeftOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeCenterXEqualRight() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeCenterXEqualRightOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeCenterXEqualTop() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeCenterXEqualTopOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeCenterXEqualBottom() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeCenterXEqualBottomOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeCenterXEqualLeading() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeCenterXEqualLeadingOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeCenterXEqualTrailing() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeCenterXEqualTrailingOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeCenterXEqualCenterX() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeCenterXEqualCenterXOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeCenterXEqualCenterY() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeCenterXEqualCenterYOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeCenterXEqualBaseline() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeCenterXEqualBaselineOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeCenterYEqualLeft() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeCenterYEqualLeftOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeCenterYEqualRight() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeCenterYEqualRightOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeCenterYEqualTop() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeCenterYEqualTopOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeCenterYEqualBottom() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeCenterYEqualBottomOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeCenterYEqualLeading() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeCenterYEqualLeadingOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeCenterYEqualTrailing() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeCenterYEqualTrailingOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeCenterYEqualCenterX() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeCenterYEqualCenterXOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeCenterYEqualCenterY() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeCenterYEqualCenterYOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeCenterYEqualBaseline() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeCenterYEqualBaselineOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeBaselineEqualLeft() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeBaselineEqualLeftOnTargetView() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeBaselineEqualRight() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeBaselineEqualRightOnTargetView() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeBaselineEqualTop() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeBaselineEqualTopOnTargetView() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeBaselineEqualBottom() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeBaselineEqualBottomOnTargetView() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeBaselineEqualLeading() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeBaselineEqualLeadingOnTargetView() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }
  
  func testMakeBaselineEqualTrailing() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }
  
  func testMakeBaselineEqualTrailingOnTargetView() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
  }
  
  func testMakeBaselineEqualCenterX() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }
  
  func testMakeBaselineEqualCenterXOnTargetView() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }
  
  func testMakeBaselineEqualCenterY() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }
  
  func testMakeBaselineEqualCenterYOnTargetView() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }
  
  func testMakeBaselineEqualBaseline() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:false)
  }
  
  func testMakeBaselineEqualBaselineOnTargetView() {
    meta_testMake(.LastBaseline, relation:.Equal, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  // MARK: - TESTS: MAKE/GREATERTHAN

  func testMakeLeftGreaterThanLeft() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeLeftGreaterThanLeftOnTargetView() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeLeftGreaterThanRight() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeLeftGreaterThanRightOnTargetView() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeLeftGreaterThanTop() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeLeftGreaterThanTopOnTargetView() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeLeftGreaterThanBottom() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeLeftGreaterThanBottomOnTargetView() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeLeftGreaterThanCenterX() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeLeftGreaterThanCenterXOnTargetView() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeLeftGreaterThanCenterY() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeLeftGreaterThanCenterYOnTargetView() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeLeftGreaterThanBaseline() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeLeftGreaterThanBaselineOnTargetView() {
    meta_testMake(.Left, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeRightGreaterThanLeft() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeRightGreaterThanLeftOnTargetView() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeRightGreaterThanRight() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeRightGreaterThanRightOnTargetView() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeRightGreaterThanTop() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeRightGreaterThanTopOnTargetView() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeRightGreaterThanBottom() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeRightGreaterThanBottomOnTargetView() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeRightGreaterThanCenterX() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeRightGreaterThanCenterXOnTargetView() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeRightGreaterThanCenterY() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeRightGreaterThanCenterYOnTargetView() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeRightGreaterThanBaseline() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeRightGreaterThanBaselineOnTargetView() {
    meta_testMake(.Right, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeTopGreaterThanLeft() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeTopGreaterThanLeftOnTargetView() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeTopGreaterThanRight() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeTopGreaterThanRightOnTargetView() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeTopGreaterThanTop() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeTopGreaterThanTopOnTargetView() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeTopGreaterThanBottom() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeTopGreaterThanBottomOnTargetView() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeTopGreaterThanLeading() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeTopGreaterThanLeadingOnTargetView() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeTopGreaterThanTrailing() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeTopGreaterThanTrailingOnTargetView() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeTopGreaterThanCenterX() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeTopGreaterThanCenterXOnTargetView() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeTopGreaterThanCenterY() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeTopGreaterThanCenterYOnTargetView() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeTopGreaterThanBaseline() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeTopGreaterThanBaselineOnTargetView() {
    meta_testMake(.Top, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeBottomGreaterThanLeft() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeBottomGreaterThanLeftOnTargetView() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeBottomGreaterThanRight() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeBottomGreaterThanRightOnTargetView() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeBottomGreaterThanTop() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeBottomGreaterThanTopOnTargetView() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeBottomGreaterThanBottom() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeBottomGreaterThanBottomOnTargetView() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeBottomGreaterThanLeading() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeBottomGreaterThanLeadingOnTargetView() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeBottomGreaterThanTrailing() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeBottomGreaterThanTrailingOnTargetView() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeBottomGreaterThanCenterX() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeBottomGreaterThanCenterXOnTargetView() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeBottomGreaterThanCenterY() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeBottomGreaterThanCenterYOnTargetView() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeBottomGreaterThanBaseline() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeBottomGreaterThanBaselineOnTargetView() {
    meta_testMake(.Bottom, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeLeadingGreaterThanTop() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeLeadingGreaterThanTopOnTargetView() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeLeadingGreaterThanBottom() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeLeadingGreaterThanBottomOnTargetView() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeLeadingGreaterThanLeading() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeLeadingGreaterThanLeadingOnTargetView() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeLeadingGreaterThanTrailing() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeLeadingGreaterThanTrailingOnTargetView() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeLeadingGreaterThanCenterX() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeLeadingGreaterThanCenterXOnTargetView() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeLeadingGreaterThanCenterY() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeLeadingGreaterThanCenterYOnTargetView() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeLeadingGreaterThanBaseline() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeLeadingGreaterThanBaselineOnTargetView() {
    meta_testMake(.Leading, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeTrailingGreaterThanTop() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeTrailingGreaterThanTopOnTargetView() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeTrailingGreaterThanBottom() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeTrailingGreaterThanBottomOnTargetView() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeTrailingGreaterThanLeading() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeTrailingGreaterThanLeadingOnTargetView() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeTrailingGreaterThanTrailing() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeTrailingGreaterThanTrailingOnTargetView() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeTrailingGreaterThanCenterX() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeTrailingGreaterThanCenterXOnTargetView() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeTrailingGreaterThanCenterY() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeTrailingGreaterThanCenterYOnTargetView() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeTrailingGreaterThanBaseline() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeTrailingGreaterThanBaselineOnTargetView() {
    meta_testMake(.Trailing, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeWidthGreaterThanWidth() {
    meta_testMake(.Width, relation:.GreaterThanOrEqual, relatedAttribute:.Width, useTargetView:false)
  }

  func testMakeWidthGreaterThanWidthOnTargetView() {
    meta_testMake(.Width, relation:.GreaterThanOrEqual, relatedAttribute:.Width, useTargetView:true)
  }

  func testMakeWidthGreaterThanHeight() {
    meta_testMake(.Width, relation:.GreaterThanOrEqual, relatedAttribute:.Height, useTargetView:false)
  }

  func testMakeWidthGreaterThanHeightOnTargetView() {
    meta_testMake(.Width, relation:.GreaterThanOrEqual, relatedAttribute:.Height, useTargetView:true)
  }

  func testMakeHeightGreaterThanWidth() {
    meta_testMake(.Height, relation:.GreaterThanOrEqual, relatedAttribute:.Width, useTargetView:false)
  }

  func testMakeHeightGreaterThanWidthOnTargetView() {
    meta_testMake(.Height, relation:.GreaterThanOrEqual, relatedAttribute:.Width, useTargetView:true)
  }

  func testMakeHeightGreaterThanHeight() {
    meta_testMake(.Height, relation:.GreaterThanOrEqual, relatedAttribute:.Height, useTargetView:false)
  }

  func testMakeHeightGreaterThanHeightOnTargetView() {
    meta_testMake(.Height, relation:.GreaterThanOrEqual, relatedAttribute:.Height, useTargetView:true)
  }

  func testMakeCenterXGreaterThanLeft() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeCenterXGreaterThanLeftOnTargetView() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeCenterXGreaterThanRight() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeCenterXGreaterThanRightOnTargetView() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeCenterXGreaterThanTop() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeCenterXGreaterThanTopOnTargetView() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeCenterXGreaterThanBottom() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeCenterXGreaterThanBottomOnTargetView() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeCenterXGreaterThanLeading() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeCenterXGreaterThanLeadingOnTargetView() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeCenterXGreaterThanTrailing() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeCenterXGreaterThanTrailingOnTargetView() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeCenterXGreaterThanCenterX() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeCenterXGreaterThanCenterXOnTargetView() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeCenterXGreaterThanCenterY() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeCenterXGreaterThanCenterYOnTargetView() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeCenterXGreaterThanBaseline() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeCenterXGreaterThanBaselineOnTargetView() {
    meta_testMake(.CenterX, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeCenterYGreaterThanLeft() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeCenterYGreaterThanLeftOnTargetView() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeCenterYGreaterThanRight() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeCenterYGreaterThanRightOnTargetView() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeCenterYGreaterThanTop() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeCenterYGreaterThanTopOnTargetView() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeCenterYGreaterThanBottom() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeCenterYGreaterThanBottomOnTargetView() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeCenterYGreaterThanLeading() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeCenterYGreaterThanLeadingOnTargetView() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeCenterYGreaterThanTrailing() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeCenterYGreaterThanTrailingOnTargetView() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeCenterYGreaterThanCenterX() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeCenterYGreaterThanCenterXOnTargetView() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeCenterYGreaterThanCenterY() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeCenterYGreaterThanCenterYOnTargetView() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeCenterYGreaterThanBaseline() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeCenterYGreaterThanBaselineOnTargetView() {
    meta_testMake(.CenterY, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeBaselineGreaterThanLeft() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeBaselineGreaterThanLeftOnTargetView() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeBaselineGreaterThanRight() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeBaselineGreaterThanRightOnTargetView() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeBaselineGreaterThanTop() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeBaselineGreaterThanTopOnTargetView() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeBaselineGreaterThanBottom() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeBaselineGreaterThanBottomOnTargetView() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeBaselineGreaterThanLeading() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeBaselineGreaterThanLeadingOnTargetView() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeBaselineGreaterThanTrailing() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeBaselineGreaterThanTrailingOnTargetView() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeBaselineGreaterThanCenterX() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeBaselineGreaterThanCenterXOnTargetView() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeBaselineGreaterThanCenterY() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeBaselineGreaterThanCenterYOnTargetView() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeBaselineGreaterThanBaseline() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeBaselineGreaterThanBaselineOnTargetView() {
    meta_testMake(.LastBaseline, relation:.GreaterThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  // MARK: - TESTS: MAKE/LESSTHAN



  func testMakeLeftLessThanLeft() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeLeftLessThanLeftOnTargetView() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeLeftLessThanRight() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeLeftLessThanRightOnTargetView() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeLeftLessThanTop() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeLeftLessThanTopOnTargetView() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeLeftLessThanBottom() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeLeftLessThanBottomOnTargetView() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeLeftLessThanCenterX() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeLeftLessThanCenterXOnTargetView() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeLeftLessThanCenterY() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeLeftLessThanCenterYOnTargetView() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeLeftLessThanBaseline() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeLeftLessThanBaselineOnTargetView() {
    meta_testMake(.Left, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeRightLessThanLeft() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeRightLessThanLeftOnTargetView() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeRightLessThanRight() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeRightLessThanRightOnTargetView() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeRightLessThanTop() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeRightLessThanTopOnTargetView() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeRightLessThanBottom() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeRightLessThanBottomOnTargetView() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeRightLessThanCenterX() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeRightLessThanCenterXOnTargetView() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeRightLessThanCenterY() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeRightLessThanCenterYOnTargetView() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeRightLessThanBaseline() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeRightLessThanBaselineOnTargetView() {
    meta_testMake(.Right, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeTopLessThanLeft() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeTopLessThanLeftOnTargetView() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeTopLessThanRight() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeTopLessThanRightOnTargetView() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeTopLessThanTop() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeTopLessThanTopOnTargetView() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeTopLessThanBottom() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeTopLessThanBottomOnTargetView() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeTopLessThanLeading() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeTopLessThanLeadingOnTargetView() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeTopLessThanTrailing() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeTopLessThanTrailingOnTargetView() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeTopLessThanCenterX() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeTopLessThanCenterXOnTargetView() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeTopLessThanCenterY() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeTopLessThanCenterYOnTargetView() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeTopLessThanBaseline() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeTopLessThanBaselineOnTargetView() {
    meta_testMake(.Top, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeBottomLessThanLeft() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeBottomLessThanLeftOnTargetView() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeBottomLessThanRight() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeBottomLessThanRightOnTargetView() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeBottomLessThanTop() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeBottomLessThanTopOnTargetView() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeBottomLessThanBottom() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeBottomLessThanBottomOnTargetView() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeBottomLessThanLeading() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeBottomLessThanLeadingOnTargetView() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeBottomLessThanTrailing() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeBottomLessThanTrailingOnTargetView() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeBottomLessThanCenterX() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeBottomLessThanCenterXOnTargetView() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeBottomLessThanCenterY() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeBottomLessThanCenterYOnTargetView() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeBottomLessThanBaseline() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeBottomLessThanBaselineOnTargetView() {
    meta_testMake(.Bottom, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeLeadingLessThanTop() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeLeadingLessThanTopOnTargetView() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeLeadingLessThanBottom() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeLeadingLessThanBottomOnTargetView() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeLeadingLessThanLeading() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeLeadingLessThanLeadingOnTargetView() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeLeadingLessThanTrailing() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeLeadingLessThanTrailingOnTargetView() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeLeadingLessThanCenterX() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeLeadingLessThanCenterXOnTargetView() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeLeadingLessThanCenterY() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeLeadingLessThanCenterYOnTargetView() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeLeadingLessThanBaseline() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeLeadingLessThanBaselineOnTargetView() {
    meta_testMake(.Leading, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeTrailingLessThanTop() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeTrailingLessThanTopOnTargetView() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeTrailingLessThanBottom() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeTrailingLessThanBottomOnTargetView() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeTrailingLessThanLeading() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeTrailingLessThanLeadingOnTargetView() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeTrailingLessThanTrailing() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeTrailingLessThanTrailingOnTargetView() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeTrailingLessThanCenterX() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeTrailingLessThanCenterXOnTargetView() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeTrailingLessThanCenterY() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeTrailingLessThanCenterYOnTargetView() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeTrailingLessThanBaseline() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeTrailingLessThanBaselineOnTargetView() {
    meta_testMake(.Trailing, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeWidthLessThanWidth() {
    meta_testMake(.Width, relation:.LessThanOrEqual, relatedAttribute:.Width, useTargetView:false)
  }

  func testMakeWidthLessThanWidthOnTargetView() {
    meta_testMake(.Width, relation:.LessThanOrEqual, relatedAttribute:.Width, useTargetView:true)
  }

  func testMakeWidthLessThanHeight() {
    meta_testMake(.Width, relation:.LessThanOrEqual, relatedAttribute:.Height, useTargetView:false)
  }

  func testMakeWidthLessThanHeightOnTargetView() {
    meta_testMake(.Width, relation:.LessThanOrEqual, relatedAttribute:.Height, useTargetView:true)
  }

  func testMakeHeightLessThanWidth() {
    meta_testMake(.Height, relation:.LessThanOrEqual, relatedAttribute:.Width, useTargetView:false)
  }

  func testMakeHeightLessThanWidthOnTargetView() {
    meta_testMake(.Height, relation:.LessThanOrEqual, relatedAttribute:.Width, useTargetView:true)
  }

  func testMakeHeightLessThanHeight() {
    meta_testMake(.Height, relation:.LessThanOrEqual, relatedAttribute:.Height, useTargetView:false)
  }

  func testMakeHeightLessThanHeightOnTargetView() {
    meta_testMake(.Height, relation:.LessThanOrEqual, relatedAttribute:.Height, useTargetView:true)
  }

  func testMakeCenterXLessThanLeft() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeCenterXLessThanLeftOnTargetView() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeCenterXLessThanRight() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeCenterXLessThanRightOnTargetView() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeCenterXLessThanTop() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeCenterXLessThanTopOnTargetView() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeCenterXLessThanBottom() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeCenterXLessThanBottomOnTargetView() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeCenterXLessThanLeading() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeCenterXLessThanLeadingOnTargetView() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeCenterXLessThanTrailing() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeCenterXLessThanTrailingOnTargetView() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeCenterXLessThanCenterX() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeCenterXLessThanCenterXOnTargetView() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeCenterXLessThanCenterY() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeCenterXLessThanCenterYOnTargetView() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeCenterXLessThanBaseline() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeCenterXLessThanBaselineOnTargetView() {
    meta_testMake(.CenterX, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeCenterYLessThanLeft() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeCenterYLessThanLeftOnTargetView() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeCenterYLessThanRight() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeCenterYLessThanRightOnTargetView() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeCenterYLessThanTop() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeCenterYLessThanTopOnTargetView() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeCenterYLessThanBottom() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeCenterYLessThanBottomOnTargetView() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeCenterYLessThanLeading() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeCenterYLessThanLeadingOnTargetView() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeCenterYLessThanTrailing() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeCenterYLessThanTrailingOnTargetView() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }

  func testMakeCenterYLessThanCenterX() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }

  func testMakeCenterYLessThanCenterXOnTargetView() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }

  func testMakeCenterYLessThanCenterY() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }

  func testMakeCenterYLessThanCenterYOnTargetView() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }

  func testMakeCenterYLessThanBaseline() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }

  func testMakeCenterYLessThanBaselineOnTargetView() {
    meta_testMake(.CenterY, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

  func testMakeBaselineLessThanLeft() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:false)
  }
  
  func testMakeBaselineLessThanLeftOnTargetView() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Left, useTargetView:true)
  }
  
  func testMakeBaselineLessThanRight() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:false)
  }
  
  func testMakeBaselineLessThanRightOnTargetView() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Right, useTargetView:true)
  }
  
  func testMakeBaselineLessThanTop() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:false)
  }
  
  func testMakeBaselineLessThanTopOnTargetView() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Top, useTargetView:true)
  }
  
  func testMakeBaselineLessThanBottom() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:false)
  }
  
  func testMakeBaselineLessThanBottomOnTargetView() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Bottom, useTargetView:true)
  }
  
  func testMakeBaselineLessThanLeading() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:false)
  }
  
  func testMakeBaselineLessThanLeadingOnTargetView() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Leading, useTargetView:true)
  }
  
  func testMakeBaselineLessThanTrailing() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:false)
  }
  
  func testMakeBaselineLessThanTrailingOnTargetView() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.Trailing, useTargetView:true)
  }
  
  func testMakeBaselineLessThanCenterX() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:false)
  }
  
  func testMakeBaselineLessThanCenterXOnTargetView() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.CenterX, useTargetView:true)
  }
  
  func testMakeBaselineLessThanCenterY() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:false)
  }
  
  func testMakeBaselineLessThanCenterYOnTargetView() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.CenterY, useTargetView:true)
  }
  
  func testMakeBaselineLessThanBaseline() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:false)
  }
  
  func testMakeBaselineLessThanBaselineOnTargetView() {
    meta_testMake(.LastBaseline, relation:.LessThanOrEqual, relatedAttribute:.LastBaseline, useTargetView:true)
  }

}
