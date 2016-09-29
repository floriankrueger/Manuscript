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

  func meta_testSet(_ attribute: NSLayoutAttribute, relation: NSLayoutRelation = .equal) {
    let constant = Helper.randomFloat(max: 100.0)
    let view = UIView(frame: CGRect.zero)
    let expectation = self.expectation(description: "constraints installed")

    Manuscript.layout(view) { c in
      switch relation {
      case .lessThanOrEqual:
        c.set(attribute, toLessThan:constant)
      case .equal:
        c.set(attribute, to:constant)
      case .greaterThanOrEqual:
        c.set(attribute, toMoreThan:constant)
      }

      expectation.fulfill()
    }

    self.waitForExpectations(timeout: 0.1) { error in
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
    meta_testSet(.width)
  }

  func testSetHeight() {
    meta_testSet(.height)
  }

  func testSetGreaterThanWidth() {
    meta_testSet(.width, relation:.greaterThanOrEqual)
  }

  func testSetGreaterThanHeight() {
    meta_testSet(.height, relation:.greaterThanOrEqual)
  }

  func testSetLessThanWidth() {
    meta_testSet(.width, relation:.lessThanOrEqual)
  }

  func testSetLessThanHeight() {
    meta_testSet(.height, relation:.lessThanOrEqual)
  }

  // MARK: - Tests: MAKE/EQUAL

  func meta_testMake(_ attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedAttribute: NSLayoutAttribute, useTargetView: Bool) {
    let constant = Helper.randomFloat(max: 100.0)
    let multiplier = Helper.randomFloat(max: 2.0)
    let parentView = UIView(frame: CGRect.zero)
    let childView = UIView(frame: CGRect.zero)
    parentView.addSubview(childView)
    let expectation = self.expectation(description: "constraints installed")

    Manuscript.layout(childView) { c in
      
      switch (relation, useTargetView) {
      case (.equal, true):
        c.make(attribute, equalTo:parentView, s:relatedAttribute, times:multiplier, plus:constant, on:parentView)
      case (.equal, false):
        c.make(attribute, equalTo:parentView, s:relatedAttribute, times:multiplier, plus:constant)
      case (.greaterThanOrEqual, true):
        c.make(attribute, greaterThan:parentView, s:relatedAttribute, times:multiplier, plus:constant, on:parentView)
      case (.greaterThanOrEqual, false):
        c.make(attribute, greaterThan:parentView, s:relatedAttribute, times:multiplier, plus:constant)
      case (.lessThanOrEqual, true):
        c.make(attribute, lessThan:parentView, s:relatedAttribute, times:multiplier, plus:constant, on:parentView)
      case (.lessThanOrEqual, false):
        c.make(attribute, lessThan:parentView, s:relatedAttribute, times:multiplier, plus:constant)
      }
      
      expectation.fulfill()
    }

    self.waitForExpectations(timeout: 0.1) { error in
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
    meta_testMake(.width, relation:.equal, relatedAttribute:.width, useTargetView:false)
  }

  func testMakeWidthEqualWidthOnTargetView() {
    meta_testMake(.width, relation:.equal, relatedAttribute:.width, useTargetView:true)
  }

  func testMakeWidthEqualHeight() {
    meta_testMake(.width, relation:.equal, relatedAttribute:.height, useTargetView:false)
  }

  func testMakeWidthEqualHeightOnTargetView() {
    meta_testMake(.width, relation:.equal, relatedAttribute:.height, useTargetView:true)
  }

  func testMakeLeftEqualLeft() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeLeftEqualLeftOnTargetView() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeLeftEqualRight() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeLeftEqualRightOnTargetView() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeLeftEqualTop() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeLeftEqualTopOnTargetView() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeLeftEqualBottom() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeLeftEqualBottomOnTargetView() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeLeftEqualCenterX() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeLeftEqualCenterXOnTargetView() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeLeftEqualCenterY() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeLeftEqualCenterYOnTargetView() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeLeftEqualBaseline() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeLeftEqualBaselineOnTargetView() {
    meta_testMake(.left, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeRightEqualLeft() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeRightEqualLeftOnTargetView() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeRightEqualRight() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeRightEqualRightOnTargetView() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeRightEqualTop() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeRightEqualTopOnTargetView() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeRightEqualBottom() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeRightEqualBottomOnTargetView() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeRightEqualCenterX() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeRightEqualCenterXOnTargetView() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeRightEqualCenterY() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeRightEqualCenterYOnTargetView() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeRightEqualBaseline() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeRightEqualBaselineOnTargetView() {
    meta_testMake(.right, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeTopEqualLeft() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeTopEqualLeftOnTargetView() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeTopEqualRight() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeTopEqualRightOnTargetView() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeTopEqualTop() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeTopEqualTopOnTargetView() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeTopEqualBottom() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeTopEqualBottomOnTargetView() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeTopEqualLeading() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeTopEqualLeadingOnTargetView() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeTopEqualTrailing() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeTopEqualTrailingOnTargetView() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeTopEqualCenterX() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeTopEqualCenterXOnTargetView() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeTopEqualCenterY() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeTopEqualCenterYOnTargetView() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeTopEqualBaseline() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeTopEqualBaselineOnTargetView() {
    meta_testMake(.top, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeBottomEqualLeft() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeBottomEqualLeftOnTargetView() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeBottomEqualRight() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeBottomEqualRightOnTargetView() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeBottomEqualTop() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeBottomEqualTopOnTargetView() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeBottomEqualBottom() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeBottomEqualBottomOnTargetView() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeBottomEqualLeading() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeBottomEqualLeadingOnTargetView() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeBottomEqualTrailing() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeBottomEqualTrailingOnTargetView() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeBottomEqualCenterX() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeBottomEqualCenterXOnTargetView() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeBottomEqualCenterY() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeBottomEqualCenterYOnTargetView() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeBottomEqualBaseline() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeBottomEqualBaselineOnTargetView() {
    meta_testMake(.bottom, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeLeadingEqualTop() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeLeadingEqualTopOnTargetView() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeLeadingEqualBottom() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeLeadingEqualBottomOnTargetView() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeLeadingEqualLeading() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeLeadingEqualLeadingOnTargetView() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeLeadingEqualTrailing() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeLeadingEqualTrailingOnTargetView() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeLeadingEqualCenterX() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeLeadingEqualCenterXOnTargetView() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeLeadingEqualCenterY() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeLeadingEqualCenterYOnTargetView() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeLeadingEqualBaseline() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeLeadingEqualBaselineOnTargetView() {
    meta_testMake(.leading, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeTrailingEqualTop() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeTrailingEqualTopOnTargetView() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeTrailingEqualBottom() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeTrailingEqualBottomOnTargetView() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeTrailingEqualLeading() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeTrailingEqualLeadingOnTargetView() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeTrailingEqualTrailing() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeTrailingEqualTrailingOnTargetView() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeTrailingEqualCenterX() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeTrailingEqualCenterXOnTargetView() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeTrailingEqualCenterY() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeTrailingEqualCenterYOnTargetView() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeTrailingEqualBaseline() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeTrailingEqualBaselineOnTargetView() {
    meta_testMake(.trailing, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeHeightEqualWidth() {
    meta_testMake(.height, relation:.equal, relatedAttribute:.width, useTargetView:false)
  }

  func testMakeHeightEqualWidthOnTargetView() {
    meta_testMake(.height, relation:.equal, relatedAttribute:.width, useTargetView:true)
  }

  func testMakeHeightEqualHeight() {
    meta_testMake(.height, relation:.equal, relatedAttribute:.height, useTargetView:false)
  }

  func testMakeHeightEqualHeightOnTargetView() {
    meta_testMake(.height, relation:.equal, relatedAttribute:.height, useTargetView:true)
  }

  func testMakeCenterXEqualLeft() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeCenterXEqualLeftOnTargetView() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeCenterXEqualRight() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeCenterXEqualRightOnTargetView() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeCenterXEqualTop() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeCenterXEqualTopOnTargetView() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeCenterXEqualBottom() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeCenterXEqualBottomOnTargetView() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeCenterXEqualLeading() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeCenterXEqualLeadingOnTargetView() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeCenterXEqualTrailing() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeCenterXEqualTrailingOnTargetView() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeCenterXEqualCenterX() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeCenterXEqualCenterXOnTargetView() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeCenterXEqualCenterY() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeCenterXEqualCenterYOnTargetView() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeCenterXEqualBaseline() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeCenterXEqualBaselineOnTargetView() {
    meta_testMake(.centerX, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeCenterYEqualLeft() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeCenterYEqualLeftOnTargetView() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeCenterYEqualRight() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeCenterYEqualRightOnTargetView() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeCenterYEqualTop() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeCenterYEqualTopOnTargetView() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeCenterYEqualBottom() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeCenterYEqualBottomOnTargetView() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeCenterYEqualLeading() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeCenterYEqualLeadingOnTargetView() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeCenterYEqualTrailing() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeCenterYEqualTrailingOnTargetView() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeCenterYEqualCenterX() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeCenterYEqualCenterXOnTargetView() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeCenterYEqualCenterY() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeCenterYEqualCenterYOnTargetView() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeCenterYEqualBaseline() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeCenterYEqualBaselineOnTargetView() {
    meta_testMake(.centerY, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeBaselineEqualLeft() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeBaselineEqualLeftOnTargetView() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeBaselineEqualRight() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeBaselineEqualRightOnTargetView() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeBaselineEqualTop() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeBaselineEqualTopOnTargetView() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeBaselineEqualBottom() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeBaselineEqualBottomOnTargetView() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeBaselineEqualLeading() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeBaselineEqualLeadingOnTargetView() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.leading, useTargetView:true)
  }
  
  func testMakeBaselineEqualTrailing() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.trailing, useTargetView:false)
  }
  
  func testMakeBaselineEqualTrailingOnTargetView() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.trailing, useTargetView:true)
  }
  
  func testMakeBaselineEqualCenterX() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.centerX, useTargetView:false)
  }
  
  func testMakeBaselineEqualCenterXOnTargetView() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.centerX, useTargetView:true)
  }
  
  func testMakeBaselineEqualCenterY() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.centerY, useTargetView:false)
  }
  
  func testMakeBaselineEqualCenterYOnTargetView() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.centerY, useTargetView:true)
  }
  
  func testMakeBaselineEqualBaseline() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:false)
  }
  
  func testMakeBaselineEqualBaselineOnTargetView() {
    meta_testMake(.lastBaseline, relation:.equal, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  // MARK: - TESTS: MAKE/GREATERTHAN

  func testMakeLeftGreaterThanLeft() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeLeftGreaterThanLeftOnTargetView() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeLeftGreaterThanRight() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeLeftGreaterThanRightOnTargetView() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeLeftGreaterThanTop() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeLeftGreaterThanTopOnTargetView() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeLeftGreaterThanBottom() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeLeftGreaterThanBottomOnTargetView() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeLeftGreaterThanCenterX() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeLeftGreaterThanCenterXOnTargetView() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeLeftGreaterThanCenterY() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeLeftGreaterThanCenterYOnTargetView() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeLeftGreaterThanBaseline() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeLeftGreaterThanBaselineOnTargetView() {
    meta_testMake(.left, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeRightGreaterThanLeft() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeRightGreaterThanLeftOnTargetView() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeRightGreaterThanRight() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeRightGreaterThanRightOnTargetView() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeRightGreaterThanTop() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeRightGreaterThanTopOnTargetView() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeRightGreaterThanBottom() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeRightGreaterThanBottomOnTargetView() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeRightGreaterThanCenterX() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeRightGreaterThanCenterXOnTargetView() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeRightGreaterThanCenterY() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeRightGreaterThanCenterYOnTargetView() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeRightGreaterThanBaseline() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeRightGreaterThanBaselineOnTargetView() {
    meta_testMake(.right, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeTopGreaterThanLeft() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeTopGreaterThanLeftOnTargetView() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeTopGreaterThanRight() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeTopGreaterThanRightOnTargetView() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeTopGreaterThanTop() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeTopGreaterThanTopOnTargetView() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeTopGreaterThanBottom() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeTopGreaterThanBottomOnTargetView() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeTopGreaterThanLeading() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeTopGreaterThanLeadingOnTargetView() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeTopGreaterThanTrailing() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeTopGreaterThanTrailingOnTargetView() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeTopGreaterThanCenterX() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeTopGreaterThanCenterXOnTargetView() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeTopGreaterThanCenterY() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeTopGreaterThanCenterYOnTargetView() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeTopGreaterThanBaseline() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeTopGreaterThanBaselineOnTargetView() {
    meta_testMake(.top, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeBottomGreaterThanLeft() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeBottomGreaterThanLeftOnTargetView() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeBottomGreaterThanRight() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeBottomGreaterThanRightOnTargetView() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeBottomGreaterThanTop() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeBottomGreaterThanTopOnTargetView() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeBottomGreaterThanBottom() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeBottomGreaterThanBottomOnTargetView() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeBottomGreaterThanLeading() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeBottomGreaterThanLeadingOnTargetView() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeBottomGreaterThanTrailing() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeBottomGreaterThanTrailingOnTargetView() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeBottomGreaterThanCenterX() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeBottomGreaterThanCenterXOnTargetView() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeBottomGreaterThanCenterY() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeBottomGreaterThanCenterYOnTargetView() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeBottomGreaterThanBaseline() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeBottomGreaterThanBaselineOnTargetView() {
    meta_testMake(.bottom, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeLeadingGreaterThanTop() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeLeadingGreaterThanTopOnTargetView() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeLeadingGreaterThanBottom() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeLeadingGreaterThanBottomOnTargetView() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeLeadingGreaterThanLeading() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeLeadingGreaterThanLeadingOnTargetView() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeLeadingGreaterThanTrailing() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeLeadingGreaterThanTrailingOnTargetView() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeLeadingGreaterThanCenterX() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeLeadingGreaterThanCenterXOnTargetView() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeLeadingGreaterThanCenterY() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeLeadingGreaterThanCenterYOnTargetView() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeLeadingGreaterThanBaseline() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeLeadingGreaterThanBaselineOnTargetView() {
    meta_testMake(.leading, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeTrailingGreaterThanTop() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeTrailingGreaterThanTopOnTargetView() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeTrailingGreaterThanBottom() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeTrailingGreaterThanBottomOnTargetView() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeTrailingGreaterThanLeading() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeTrailingGreaterThanLeadingOnTargetView() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeTrailingGreaterThanTrailing() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeTrailingGreaterThanTrailingOnTargetView() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeTrailingGreaterThanCenterX() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeTrailingGreaterThanCenterXOnTargetView() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeTrailingGreaterThanCenterY() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeTrailingGreaterThanCenterYOnTargetView() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeTrailingGreaterThanBaseline() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeTrailingGreaterThanBaselineOnTargetView() {
    meta_testMake(.trailing, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeWidthGreaterThanWidth() {
    meta_testMake(.width, relation:.greaterThanOrEqual, relatedAttribute:.width, useTargetView:false)
  }

  func testMakeWidthGreaterThanWidthOnTargetView() {
    meta_testMake(.width, relation:.greaterThanOrEqual, relatedAttribute:.width, useTargetView:true)
  }

  func testMakeWidthGreaterThanHeight() {
    meta_testMake(.width, relation:.greaterThanOrEqual, relatedAttribute:.height, useTargetView:false)
  }

  func testMakeWidthGreaterThanHeightOnTargetView() {
    meta_testMake(.width, relation:.greaterThanOrEqual, relatedAttribute:.height, useTargetView:true)
  }

  func testMakeHeightGreaterThanWidth() {
    meta_testMake(.height, relation:.greaterThanOrEqual, relatedAttribute:.width, useTargetView:false)
  }

  func testMakeHeightGreaterThanWidthOnTargetView() {
    meta_testMake(.height, relation:.greaterThanOrEqual, relatedAttribute:.width, useTargetView:true)
  }

  func testMakeHeightGreaterThanHeight() {
    meta_testMake(.height, relation:.greaterThanOrEqual, relatedAttribute:.height, useTargetView:false)
  }

  func testMakeHeightGreaterThanHeightOnTargetView() {
    meta_testMake(.height, relation:.greaterThanOrEqual, relatedAttribute:.height, useTargetView:true)
  }

  func testMakeCenterXGreaterThanLeft() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeCenterXGreaterThanLeftOnTargetView() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeCenterXGreaterThanRight() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeCenterXGreaterThanRightOnTargetView() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeCenterXGreaterThanTop() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeCenterXGreaterThanTopOnTargetView() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeCenterXGreaterThanBottom() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeCenterXGreaterThanBottomOnTargetView() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeCenterXGreaterThanLeading() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeCenterXGreaterThanLeadingOnTargetView() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeCenterXGreaterThanTrailing() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeCenterXGreaterThanTrailingOnTargetView() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeCenterXGreaterThanCenterX() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeCenterXGreaterThanCenterXOnTargetView() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeCenterXGreaterThanCenterY() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeCenterXGreaterThanCenterYOnTargetView() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeCenterXGreaterThanBaseline() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeCenterXGreaterThanBaselineOnTargetView() {
    meta_testMake(.centerX, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeCenterYGreaterThanLeft() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeCenterYGreaterThanLeftOnTargetView() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeCenterYGreaterThanRight() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeCenterYGreaterThanRightOnTargetView() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeCenterYGreaterThanTop() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeCenterYGreaterThanTopOnTargetView() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeCenterYGreaterThanBottom() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeCenterYGreaterThanBottomOnTargetView() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeCenterYGreaterThanLeading() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeCenterYGreaterThanLeadingOnTargetView() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeCenterYGreaterThanTrailing() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeCenterYGreaterThanTrailingOnTargetView() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeCenterYGreaterThanCenterX() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeCenterYGreaterThanCenterXOnTargetView() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeCenterYGreaterThanCenterY() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeCenterYGreaterThanCenterYOnTargetView() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeCenterYGreaterThanBaseline() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeCenterYGreaterThanBaselineOnTargetView() {
    meta_testMake(.centerY, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeBaselineGreaterThanLeft() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeBaselineGreaterThanLeftOnTargetView() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeBaselineGreaterThanRight() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeBaselineGreaterThanRightOnTargetView() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeBaselineGreaterThanTop() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeBaselineGreaterThanTopOnTargetView() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeBaselineGreaterThanBottom() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeBaselineGreaterThanBottomOnTargetView() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeBaselineGreaterThanLeading() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeBaselineGreaterThanLeadingOnTargetView() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeBaselineGreaterThanTrailing() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeBaselineGreaterThanTrailingOnTargetView() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeBaselineGreaterThanCenterX() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeBaselineGreaterThanCenterXOnTargetView() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeBaselineGreaterThanCenterY() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeBaselineGreaterThanCenterYOnTargetView() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeBaselineGreaterThanBaseline() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeBaselineGreaterThanBaselineOnTargetView() {
    meta_testMake(.lastBaseline, relation:.greaterThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  // MARK: - TESTS: MAKE/LESSTHAN



  func testMakeLeftLessThanLeft() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeLeftLessThanLeftOnTargetView() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeLeftLessThanRight() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeLeftLessThanRightOnTargetView() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeLeftLessThanTop() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeLeftLessThanTopOnTargetView() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeLeftLessThanBottom() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeLeftLessThanBottomOnTargetView() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeLeftLessThanCenterX() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeLeftLessThanCenterXOnTargetView() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeLeftLessThanCenterY() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeLeftLessThanCenterYOnTargetView() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeLeftLessThanBaseline() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeLeftLessThanBaselineOnTargetView() {
    meta_testMake(.left, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeRightLessThanLeft() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeRightLessThanLeftOnTargetView() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeRightLessThanRight() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeRightLessThanRightOnTargetView() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeRightLessThanTop() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeRightLessThanTopOnTargetView() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeRightLessThanBottom() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeRightLessThanBottomOnTargetView() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeRightLessThanCenterX() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeRightLessThanCenterXOnTargetView() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeRightLessThanCenterY() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeRightLessThanCenterYOnTargetView() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeRightLessThanBaseline() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeRightLessThanBaselineOnTargetView() {
    meta_testMake(.right, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeTopLessThanLeft() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeTopLessThanLeftOnTargetView() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeTopLessThanRight() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeTopLessThanRightOnTargetView() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeTopLessThanTop() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeTopLessThanTopOnTargetView() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeTopLessThanBottom() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeTopLessThanBottomOnTargetView() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeTopLessThanLeading() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeTopLessThanLeadingOnTargetView() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeTopLessThanTrailing() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeTopLessThanTrailingOnTargetView() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeTopLessThanCenterX() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeTopLessThanCenterXOnTargetView() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeTopLessThanCenterY() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeTopLessThanCenterYOnTargetView() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeTopLessThanBaseline() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeTopLessThanBaselineOnTargetView() {
    meta_testMake(.top, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeBottomLessThanLeft() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeBottomLessThanLeftOnTargetView() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeBottomLessThanRight() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeBottomLessThanRightOnTargetView() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeBottomLessThanTop() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeBottomLessThanTopOnTargetView() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeBottomLessThanBottom() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeBottomLessThanBottomOnTargetView() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeBottomLessThanLeading() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeBottomLessThanLeadingOnTargetView() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeBottomLessThanTrailing() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeBottomLessThanTrailingOnTargetView() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeBottomLessThanCenterX() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeBottomLessThanCenterXOnTargetView() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeBottomLessThanCenterY() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeBottomLessThanCenterYOnTargetView() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeBottomLessThanBaseline() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeBottomLessThanBaselineOnTargetView() {
    meta_testMake(.bottom, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeLeadingLessThanTop() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeLeadingLessThanTopOnTargetView() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeLeadingLessThanBottom() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeLeadingLessThanBottomOnTargetView() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeLeadingLessThanLeading() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeLeadingLessThanLeadingOnTargetView() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeLeadingLessThanTrailing() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeLeadingLessThanTrailingOnTargetView() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeLeadingLessThanCenterX() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeLeadingLessThanCenterXOnTargetView() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeLeadingLessThanCenterY() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeLeadingLessThanCenterYOnTargetView() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeLeadingLessThanBaseline() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeLeadingLessThanBaselineOnTargetView() {
    meta_testMake(.leading, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeTrailingLessThanTop() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeTrailingLessThanTopOnTargetView() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeTrailingLessThanBottom() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeTrailingLessThanBottomOnTargetView() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeTrailingLessThanLeading() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeTrailingLessThanLeadingOnTargetView() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeTrailingLessThanTrailing() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeTrailingLessThanTrailingOnTargetView() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeTrailingLessThanCenterX() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeTrailingLessThanCenterXOnTargetView() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeTrailingLessThanCenterY() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeTrailingLessThanCenterYOnTargetView() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeTrailingLessThanBaseline() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeTrailingLessThanBaselineOnTargetView() {
    meta_testMake(.trailing, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeWidthLessThanWidth() {
    meta_testMake(.width, relation:.lessThanOrEqual, relatedAttribute:.width, useTargetView:false)
  }

  func testMakeWidthLessThanWidthOnTargetView() {
    meta_testMake(.width, relation:.lessThanOrEqual, relatedAttribute:.width, useTargetView:true)
  }

  func testMakeWidthLessThanHeight() {
    meta_testMake(.width, relation:.lessThanOrEqual, relatedAttribute:.height, useTargetView:false)
  }

  func testMakeWidthLessThanHeightOnTargetView() {
    meta_testMake(.width, relation:.lessThanOrEqual, relatedAttribute:.height, useTargetView:true)
  }

  func testMakeHeightLessThanWidth() {
    meta_testMake(.height, relation:.lessThanOrEqual, relatedAttribute:.width, useTargetView:false)
  }

  func testMakeHeightLessThanWidthOnTargetView() {
    meta_testMake(.height, relation:.lessThanOrEqual, relatedAttribute:.width, useTargetView:true)
  }

  func testMakeHeightLessThanHeight() {
    meta_testMake(.height, relation:.lessThanOrEqual, relatedAttribute:.height, useTargetView:false)
  }

  func testMakeHeightLessThanHeightOnTargetView() {
    meta_testMake(.height, relation:.lessThanOrEqual, relatedAttribute:.height, useTargetView:true)
  }

  func testMakeCenterXLessThanLeft() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeCenterXLessThanLeftOnTargetView() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeCenterXLessThanRight() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeCenterXLessThanRightOnTargetView() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeCenterXLessThanTop() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeCenterXLessThanTopOnTargetView() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeCenterXLessThanBottom() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeCenterXLessThanBottomOnTargetView() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeCenterXLessThanLeading() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeCenterXLessThanLeadingOnTargetView() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeCenterXLessThanTrailing() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeCenterXLessThanTrailingOnTargetView() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeCenterXLessThanCenterX() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeCenterXLessThanCenterXOnTargetView() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeCenterXLessThanCenterY() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeCenterXLessThanCenterYOnTargetView() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeCenterXLessThanBaseline() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeCenterXLessThanBaselineOnTargetView() {
    meta_testMake(.centerX, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeCenterYLessThanLeft() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }

  func testMakeCenterYLessThanLeftOnTargetView() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }

  func testMakeCenterYLessThanRight() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }

  func testMakeCenterYLessThanRightOnTargetView() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }

  func testMakeCenterYLessThanTop() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }

  func testMakeCenterYLessThanTopOnTargetView() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }

  func testMakeCenterYLessThanBottom() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }

  func testMakeCenterYLessThanBottomOnTargetView() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }

  func testMakeCenterYLessThanLeading() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }

  func testMakeCenterYLessThanLeadingOnTargetView() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }

  func testMakeCenterYLessThanTrailing() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }

  func testMakeCenterYLessThanTrailingOnTargetView() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }

  func testMakeCenterYLessThanCenterX() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }

  func testMakeCenterYLessThanCenterXOnTargetView() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }

  func testMakeCenterYLessThanCenterY() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }

  func testMakeCenterYLessThanCenterYOnTargetView() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }

  func testMakeCenterYLessThanBaseline() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }

  func testMakeCenterYLessThanBaselineOnTargetView() {
    meta_testMake(.centerY, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

  func testMakeBaselineLessThanLeft() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:false)
  }
  
  func testMakeBaselineLessThanLeftOnTargetView() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.left, useTargetView:true)
  }
  
  func testMakeBaselineLessThanRight() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:false)
  }
  
  func testMakeBaselineLessThanRightOnTargetView() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.right, useTargetView:true)
  }
  
  func testMakeBaselineLessThanTop() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:false)
  }
  
  func testMakeBaselineLessThanTopOnTargetView() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.top, useTargetView:true)
  }
  
  func testMakeBaselineLessThanBottom() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:false)
  }
  
  func testMakeBaselineLessThanBottomOnTargetView() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.bottom, useTargetView:true)
  }
  
  func testMakeBaselineLessThanLeading() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:false)
  }
  
  func testMakeBaselineLessThanLeadingOnTargetView() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.leading, useTargetView:true)
  }
  
  func testMakeBaselineLessThanTrailing() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:false)
  }
  
  func testMakeBaselineLessThanTrailingOnTargetView() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.trailing, useTargetView:true)
  }
  
  func testMakeBaselineLessThanCenterX() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:false)
  }
  
  func testMakeBaselineLessThanCenterXOnTargetView() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.centerX, useTargetView:true)
  }
  
  func testMakeBaselineLessThanCenterY() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:false)
  }
  
  func testMakeBaselineLessThanCenterYOnTargetView() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.centerY, useTargetView:true)
  }
  
  func testMakeBaselineLessThanBaseline() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:false)
  }
  
  func testMakeBaselineLessThanBaselineOnTargetView() {
    meta_testMake(.lastBaseline, relation:.lessThanOrEqual, relatedAttribute:.lastBaseline, useTargetView:true)
  }

}
