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

  func checkConstraint(
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

  // MARK: - Tests (SET)

  func meta_testSet(attribute: NSLayoutAttribute) {
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

  func testSetWidth() {
    meta_testSet(.Width)
  }

  func testSetHeight() {
    meta_testSet(.Height)
  }

  // MARK: - Tests (MAKE)

  func meta_testMake(attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedAttribute: NSLayoutAttribute, useTargetView: Bool) {
    let constant = self.randomFloat(max: 100.0)
    let multiplier = self.randomFloat(max: 2.0)
    let parentView = UIView(frame: CGRectZero)
    let childView = UIView(frame: CGRectZero)
    parentView.addSubview(childView)
    let expectation = self.expectationWithDescription("constraints installed")

    Manuscript.layout(childView) { c in
      if useTargetView {
        c.make(attribute, equalTo:parentView, s:relatedAttribute, times:multiplier, plus:constant, on:parentView)
      } else {
        c.make(attribute, equalTo:parentView, s:relatedAttribute, times:multiplier, plus:constant)
      }
      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.1) { error in
      if let constraint = self.firstConstraint(parentView, withAttribute:attribute) {
        self.checkConstraint(constraint, item:childView, attribute:attribute, relation:.Equal, relatedItem:parentView, relatedAttribute:relatedAttribute, multiplier:multiplier, constant:constant)
      } else {
        XCTFail("parentView is expected to have at least one constraint for attribute \(attribute)")
      }
      XCTAssertEqual(1, parentView.constraints().count, "parentView is expected to have one constraint only")
      XCTAssertEqual(0, childView.constraints().count, "childView is expected to have no constraint")
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

  func testMakeLeftEqualLeading() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeLeftEqualLeadingOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeLeftEqualTrailing() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeLeftEqualTrailingOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
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
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Baseline, useTargetView:false)
  }

  func testMakeLeftEqualBaselineOnTargetView() {
    meta_testMake(.Left, relation:.Equal, relatedAttribute:.Baseline, useTargetView:true)
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

  func testMakeRightEqualLeading() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeRightEqualLeadingOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }

  func testMakeRightEqualTrailing() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }

  func testMakeRightEqualTrailingOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
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
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Baseline, useTargetView:false)
  }

  func testMakeRightEqualBaselineOnTargetView() {
    meta_testMake(.Right, relation:.Equal, relatedAttribute:.Baseline, useTargetView:true)
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
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Baseline, useTargetView:false)
  }

  func testMakeTopEqualBaselineOnTargetView() {
    meta_testMake(.Top, relation:.Equal, relatedAttribute:.Baseline, useTargetView:true)
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
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Baseline, useTargetView:false)
  }

  func testMakeBottomEqualBaselineOnTargetView() {
    meta_testMake(.Bottom, relation:.Equal, relatedAttribute:.Baseline, useTargetView:true)
  }

  func testMakeLeadingEqualLeft() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeLeadingEqualLeftOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeLeadingEqualRight() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeLeadingEqualRightOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
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
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Baseline, useTargetView:false)
  }

  func testMakeLeadingEqualBaselineOnTargetView() {
    meta_testMake(.Leading, relation:.Equal, relatedAttribute:.Baseline, useTargetView:true)
  }

  func testMakeTrailingEqualLeft() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeTrailingEqualLeftOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeTrailingEqualRight() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeTrailingEqualRightOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
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
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Baseline, useTargetView:false)
  }

  func testMakeTrailingEqualBaselineOnTargetView() {
    meta_testMake(.Trailing, relation:.Equal, relatedAttribute:.Baseline, useTargetView:true)
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
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Baseline, useTargetView:false)
  }

  func testMakeCenterXEqualBaselineOnTargetView() {
    meta_testMake(.CenterX, relation:.Equal, relatedAttribute:.Baseline, useTargetView:true)
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
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Baseline, useTargetView:false)
  }

  func testMakeCenterYEqualBaselineOnTargetView() {
    meta_testMake(.CenterY, relation:.Equal, relatedAttribute:.Baseline, useTargetView:true)
  }

  func testMakeBaselineEqualLeft() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Left, useTargetView:false)
  }

  func testMakeBaselineEqualLeftOnTargetView() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Left, useTargetView:true)
  }

  func testMakeBaselineEqualRight() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Right, useTargetView:false)
  }

  func testMakeBaselineEqualRightOnTargetView() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Right, useTargetView:true)
  }

  func testMakeBaselineEqualTop() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Top, useTargetView:false)
  }

  func testMakeBaselineEqualTopOnTargetView() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Top, useTargetView:true)
  }

  func testMakeBaselineEqualBottom() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Bottom, useTargetView:false)
  }

  func testMakeBaselineEqualBottomOnTargetView() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Bottom, useTargetView:true)
  }

  func testMakeBaselineEqualLeading() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Leading, useTargetView:false)
  }

  func testMakeBaselineEqualLeadingOnTargetView() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Leading, useTargetView:true)
  }
  
  func testMakeBaselineEqualTrailing() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Trailing, useTargetView:false)
  }
  
  func testMakeBaselineEqualTrailingOnTargetView() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Trailing, useTargetView:true)
  }
  
  func testMakeBaselineEqualCenterX() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.CenterX, useTargetView:false)
  }
  
  func testMakeBaselineEqualCenterXOnTargetView() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.CenterX, useTargetView:true)
  }
  
  func testMakeBaselineEqualCenterY() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.CenterY, useTargetView:false)
  }
  
  func testMakeBaselineEqualCenterYOnTargetView() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.CenterY, useTargetView:true)
  }
  
  func testMakeBaselineEqualBaseline() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Baseline, useTargetView:false)
  }
  
  func testMakeBaselineEqualBaselineOnTargetView() {
    meta_testMake(.Baseline, relation:.Equal, relatedAttribute:.Baseline, useTargetView:true)
  }

}
