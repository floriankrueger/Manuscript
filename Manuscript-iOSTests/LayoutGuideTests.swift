//
//  LayoutGuideTests.swift
//  Manuscript
//
//  Created by Florian Krüger on 27/08/15.
//  Copyright © 2015 projectserver.org. All rights reserved.
//

import UIKit
import XCTest
import Manuscript

class LayoutGuideTests : XCTestCase {

  func testCreateConstraintWithLayoutGuide() {

    let viewController = UIViewController(nibName: nil, bundle: nil)
    let aView = UIView(frame: CGRectZero)
    viewController.view.addSubview(aView)

    var topLayoutItem: LayoutItem? = nil

    // make Layout Constraints

    Manuscript.layout(aView) { c in
      topLayoutItem = c.make(.Top, equalTo: viewController.topLayoutGuide, s: .LastBaseline, plus: 10.0)
    }

    XCTAssertNotNil(topLayoutItem)
    XCTAssertNotNil(topLayoutItem!.constraint)
    XCTAssertNotNil(topLayoutItem!.targetItem)

    XCTAssertEqual(topLayoutItem!.targetItem, viewController.view)
  }

}
