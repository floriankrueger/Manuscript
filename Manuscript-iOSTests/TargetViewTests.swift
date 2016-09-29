//
//  TargetViewTests.swift
//  Manuscript
//
//  Created by Florian Krüger on 26/04/15.
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
@testable import Manuscript

class TargetViewTests: XCTestCase {

  func testCreatesUnrelatedConstraintOnTheGivenItemWhenUsingSet() {
    let view = UIView(frame: CGRectZero)
    var layoutItem: LayoutItem? = nil

    Manuscript.layout(view) { c in
      layoutItem = c.set(.Width, to: 100.0)
    }

    if let aLayoutItem = layoutItem {
      XCTAssertEqual(aLayoutItem.targetItem, view, "")
    } else {
      XCTFail("expected a layout item to be created")
    }
  }

  func testCreatedRelatedConstraintOnTheSpecifiedItemWhenUsingMakeOn() {
    let parentView = UIView(frame: CGRectZero)
    let childView = UIView(frame: CGRectZero)
    parentView.addSubview(childView)

    var layoutItem: LayoutItem? = nil

    Manuscript.layout(childView) { c in
      layoutItem = c.make(.Width, equalTo:parentView, s:.Width, on:parentView)
    }

    XCTAssertEqual(childView.constraints.count, 0, "")
    XCTAssertEqual(parentView.constraints.count, 1, "")
    XCTAssertEqual(parentView, layoutItem!.targetItem, "")
  }

  func testCreatedRelatedConstraintOnTheParentItemWhenUsingMake() {
    let parentView = UIView(frame: CGRectZero)
    let childView = UIView(frame: CGRectZero)
    parentView.addSubview(childView)

    var layoutItem: LayoutItem? = nil

    Manuscript.layout(childView) { c in
      layoutItem = c.make(.Width, equalTo:parentView, s:.Width)
    }

    XCTAssertEqual(childView.constraints.count, 0, "")
    XCTAssertEqual(parentView.constraints.count, 1, "")
    XCTAssertEqual(parentView, layoutItem!.targetItem, "")
  }

  func testCreatedRelatedConstraintOnTheCommonParentItemWhenUsingMake() {
    let parentView = UIView(frame: CGRectZero)
    let childView1 = UIView(frame: CGRectZero)
    let childView2 = UIView(frame: CGRectZero)
    parentView.addSubview(childView1)
    parentView.addSubview(childView2)

    var layoutItem: LayoutItem? = nil

    Manuscript.layout(childView1) { c in
      layoutItem = c.make(.Width, equalTo:childView2, s:.Width)
    }

    XCTAssertEqual(childView1.constraints.count, 0, "")
    XCTAssertEqual(childView2.constraints.count, 0, "")
    XCTAssertEqual(parentView.constraints.count, 1, "")
    XCTAssertEqual(parentView, layoutItem!.targetItem, "")
  }
  
  func testSimpleFindCommonSuperview() {
    let parentView = UIView()
    let childView = UIView()
    
    parentView.addSubview(childView)
    
    XCTAssertEqual(parentView, Manuscript.findCommonSuperview(childView, b: parentView))
    XCTAssertEqual(parentView, Manuscript.findCommonSuperview(parentView, b: childView))
  }
  
  func testTransitiveFindCommonSuperview() {
    let parentView = UIView()
    let childView = UIView()
    let subChildView = UIView()
    
    parentView.addSubview(childView)
    childView.addSubview(subChildView)
    
    XCTAssertEqual(parentView, Manuscript.findCommonSuperview(subChildView, b: parentView))
    XCTAssertEqual(parentView, Manuscript.findCommonSuperview(parentView, b: subChildView))
  }
  
  func testFailingFindCommonSuperview() {
    let view1 = UIView()
    let view2 = UIView()
    
    XCTAssertEqual(view1, Manuscript.findCommonSuperview(view1, b: nil))
    XCTAssertNil(Manuscript.findCommonSuperview(view1, b: view2))
  }

}
