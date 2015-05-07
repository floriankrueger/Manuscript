//
//  PriorityTests.swift
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

class PriorityTests: XCTestCase {

  private var view: UIView = UIView(frame: CGRectZero)

  override func setUp() {
    super.setUp()
    self.view = UIView(frame: CGRectZero)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testDefaultPriority() {
    var layoutItem: Manuscript.LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      layoutItem = c.set(.Width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.priority, 1000, "Expected Required Priority by Default")
  }

  func testSetPriorityExplicit() {
    var layoutItem: Manuscript.LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      c.setPriority(123)
      layoutItem = c.set(.Width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.priority, 123, "Expected explicit Priority of 123")
  }

  func testSetPriorityLowerBoundTo1() {
    var layoutItem: Manuscript.LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      c.setPriority(0)
      layoutItem = c.set(.Width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.priority, 1, "Expected a lower cap of 1")
  }

  func testSetPriorityUpperBoundTo1000() {
    var layoutItem: Manuscript.LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      c.setPriority(1001)
      layoutItem = c.set(.Width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.priority, 1000, "Expected a upper cap of 1000")
  }

  func testResetPriority() {
    var layoutItem: Manuscript.LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      c.setPriority(123)
      c.set(.Height, to: 100.0)

      c.setPriorityRequired()
      layoutItem = c.set(.Width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.priority, 1000, "Expected Required Priority")
  }

  func testSetPriorityRequired() {
    var layoutItem: Manuscript.LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      c.setPriorityRequired()
      layoutItem = c.set(.Width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.priority, 1000, "Expected Required Priority (1000)")
  }

  func testSetPriorityDefaultHigh() {
    var layoutItem: Manuscript.LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      c.setPriorityDefaultHigh()
      layoutItem = c.set(.Width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.priority, 750, "Expected Default High Priority (750)")
  }

  func testSetPriorityDefaultLow() {
    var layoutItem: Manuscript.LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      c.setPriorityDefaultLow()
      layoutItem = c.set(.Width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.priority, 250, "Expected Default High Priority (250)")
  }

  func testSetPriorityFittingSizeLevel() {
    var layoutItem: Manuscript.LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      c.setPriorityFittingSizeLevel()
      layoutItem = c.set(.Width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.priority, 50, "Expected Default High Priority (250)")
  }
}
