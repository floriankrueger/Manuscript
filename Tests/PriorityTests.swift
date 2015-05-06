//
//  PriorityTests.swift
//  Manuscript
//
//  Created by Florian Krüger on 06/05/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//

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

}
