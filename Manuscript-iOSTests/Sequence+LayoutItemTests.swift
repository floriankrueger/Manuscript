//
//  Sequence+LayoutItemTests.swift
//  Manuscript
//
//  Created by Florian Krüger on 09/02/2017.
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

class Sequence_LayoutItemTests: XCTestCase {
    
  func testUninstall() {
    
    let view = UIView(frame: CGRect.zero)
    let subview = UIView(frame: CGRect.zero)
    
    view.addSubview(subview)
    
    var optHeightItem: LayoutItem? = nil
    var optWidthItem: LayoutItem? = nil
    
    let proxy = Manuscript.layout(subview) { c in
      optHeightItem = c.set(.height, to: 10.0)
      optWidthItem = c.make(.width, equalTo: view, s: .width)
    }
    
    guard let heightItem = optHeightItem, let widthItem = optWidthItem else { XCTFail("items not initialized"); return }
    
    XCTAssertTrue(heightItem.targetItem.constraints.contains(heightItem.constraint))
    XCTAssertTrue(widthItem.targetItem.constraints.contains(widthItem.constraint))
    
    proxy.items.constraints.uninstall()
    
    XCTAssertFalse(heightItem.targetItem.constraints.contains(heightItem.constraint))
    XCTAssertFalse(widthItem.targetItem.constraints.contains(widthItem.constraint))
    
  }
  
  func testActivationAndDeactivation() {
    
    let view = UIView(frame: CGRect.zero)
    let subview = UIView(frame: CGRect.zero)
    
    view.addSubview(subview)
    
    var optHeightItem: LayoutItem? = nil
    var optWidthItem: LayoutItem? = nil
    
    let proxy = Manuscript.layout(subview) { c in
      optHeightItem = c.set(.height, to: 10.0)
      optWidthItem = c.make(.width, equalTo: view, s: .width)
    }
    
    guard let heightItem = optHeightItem, let widthItem = optWidthItem else { XCTFail("items not initialized"); return }
    
    XCTAssertTrue(heightItem.constraint.isActive)
    XCTAssertTrue(widthItem.constraint.isActive)
    
    proxy.items.constraints.deactivate()
    
    XCTAssertFalse(heightItem.constraint.isActive)
    XCTAssertFalse(widthItem.constraint.isActive)
    
    proxy.items.constraints.activate()
    
    XCTAssertTrue(heightItem.constraint.isActive)
    XCTAssertTrue(widthItem.constraint.isActive)
    
  }
  
}
