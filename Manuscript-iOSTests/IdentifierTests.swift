//
//  IdentifierTests.swift
//  Manuscript
//
//  Created by Florian Krüger on 12/11/15.
//  Copyright © 2015 projectserver.org. All rights reserved.
//

import XCTest
import Manuscript

class IdentifierTests: XCTestCase {

  fileprivate var view: UIView = UIView(frame: CGRect.zero)

  override func setUp() {
    super.setUp()
    self.view = UIView(frame: CGRect.zero)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testDefaultIdentifier() {
    var layoutItem: LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      layoutItem = c.set(.width, to: 100.0)
    }

    XCTAssertEqual(layoutItem!.constraint.identifier, "MNSCRPT", "Expected a default identifier: 'MNSCRPT'")
  }

  func testCustomIdentifier() {
    let identifier = "CUSTOM_IDENTIFIER"
    var layoutItem: LayoutItem? = nil

    Manuscript.layout(self.view) { c in
      c.setPriority(123)
      layoutItem = c.set(.width, to: 100.0, identifier: identifier)
    }

    XCTAssertEqual(layoutItem!.constraint.identifier, identifier, "Expected a custom identifier: '\(identifier)'")
  }

  func testConvenienceDefaultIdentifiersAlignAllEdges() {
    self.convenienceIdentifiersAlignAllEdgesWithPrefix(nil)
  }

  func testConvenienceCustomIdentifiersAlignAllEdges() {
    self.convenienceIdentifiersAlignAllEdgesWithPrefix("CUSTOM_IDENTIFIER")
  }

  func convenienceIdentifiersAlignAllEdgesWithPrefix(_ prefix: String?) {
    let parentView = UIView(frame: CGRect.zero)
    let childView = UIView(frame: CGRect.zero)
    parentView.addSubview(childView)
    let expectation = self.expectation(description: "constraints installed")

    var layoutItems: [LayoutItem]? = nil

    Manuscript.layout(childView) { c in
      layoutItems = c.alignAllEdges(to: parentView, identifier: prefix)
      expectation.fulfill()
    }

    let checkPrefix = prefix ?? Manuscript.defaultIdentifier

    self.waitForExpectations(timeout: 0.1) { error in
      guard let items = layoutItems else { XCTFail("layoutItems must not be nil"); return }
      XCTAssertEqual(items[0].constraint.identifier, "\(checkPrefix)_left")
      XCTAssertEqual(items[1].constraint.identifier, "\(checkPrefix)_top")
      XCTAssertEqual(items[2].constraint.identifier, "\(checkPrefix)_right")
      XCTAssertEqual(items[3].constraint.identifier, "\(checkPrefix)_bottom")
      XCTAssertNil(error, "")
    }
  }

  func testConvenienceDefaultIdentifiersCenterIn() {
    self.convenienceIdentifiersCenterInWithPrefix(nil)
  }

  func testConvenienceCustomIdentifiersCenterIn() {
    self.convenienceIdentifiersCenterInWithPrefix("CUSTOM_IDENTIFIER")
  }

  func convenienceIdentifiersCenterInWithPrefix(_ prefix: String?) {
    let parentView = UIView(frame: CGRect.zero)
    let childView = UIView(frame: CGRect.zero)
    parentView.addSubview(childView)
    let expectation = self.expectation(description: "constraints installed")

    var layoutItems: [LayoutItem]? = nil

    Manuscript.layout(childView) { c in
      layoutItems = c.centerIn(parentView, identifier: prefix)
      expectation.fulfill()
    }

    let checkPrefix = prefix ?? Manuscript.defaultIdentifier

    self.waitForExpectations(timeout: 0.1) { error in
      guard let items = layoutItems else { XCTFail("layoutItems must not be nil"); return }
      XCTAssertEqual(items[0].constraint.identifier, "\(checkPrefix)_center_x")
      XCTAssertEqual(items[1].constraint.identifier, "\(checkPrefix)_center_y")
      XCTAssertNil(error, "")
    }
  }

  func testConvenienceDefaultIdentifiersSetSize() {
    self.convenienceIdentifiersSetSizeWithPrefix(nil)
  }

  func testConvenienceCustomIdentifiersSetSize() {
    self.convenienceIdentifiersSetSizeWithPrefix("CUSTOM_IDENTIFIER")
  }

  func convenienceIdentifiersSetSizeWithPrefix(_ prefix: String?) {
    let view = UIView(frame: CGRect.zero)
    let width:CGFloat = 100.0
    let height:CGFloat = 200.0
    let expectation = self.expectation(description: "constraints installed")

    var layoutItems: [LayoutItem]? = nil

    Manuscript.layout(view) { c in
      layoutItems = c.setSize(CGSize(width: width, height: height), identifier: prefix)
      expectation.fulfill()
    }

    let checkPrefix = prefix ?? Manuscript.defaultIdentifier

    self.waitForExpectations(timeout: 0.1) { error in
      guard let items = layoutItems else { XCTFail("layoutItems must not be nil"); return }
      XCTAssertEqual(items[0].constraint.identifier, "\(checkPrefix)_height")
      XCTAssertEqual(items[1].constraint.identifier, "\(checkPrefix)_width")
      XCTAssertNil(error, "")
    }
  }
}
