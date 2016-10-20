//
//  SimpleButtonExampleViewController.swift
//  Example
//
//  Created by Florian Krüger on 25/04/15.
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
import Manuscript

class SimpleButtonExampleViewController: UIViewController {

  // MARK: Private Properties

  fileprivate var activeButton: UIButton? = nil

  fileprivate let optionA: UIButton = UIButton(type: .system)
  fileprivate let optionB: UIButton = UIButton(type: .system)
  fileprivate let optionC: UIButton = UIButton(type: .system)

  fileprivate let buttonDimSmall:CGFloat = 60.0
  fileprivate let buttonDimBig:CGFloat = 80.0

  fileprivate var optionAHeight: NSLayoutConstraint? = nil
  fileprivate var optionAWidth: NSLayoutConstraint? = nil
  fileprivate var optionBHeight: NSLayoutConstraint? = nil
  fileprivate var optionBWidth: NSLayoutConstraint? = nil
  fileprivate var optionCHeight: NSLayoutConstraint? = nil
  fileprivate var optionCWidth: NSLayoutConstraint? = nil

  // MARK: - Init

  init() {
    super.init(nibName: nil, bundle: nil)
    title = "Buttons"
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }

  // MARK: - View

  override func loadView() {
    super.loadView()

    view.backgroundColor = UIColor.gray

    setupSubviews()
    setupLayout()
  }

  // MARK: - Target

  func buttonPressed(_ sender: UIButton) {
    if sender == activeButton {
      return;
    }

    if let activeButton = activeButton {
      switch activeButton {
      case optionA:
        optionAHeight?.constant = buttonDimSmall
        optionAWidth?.constant = buttonDimSmall
        optionA.setNeedsLayout()
      case optionB:
        optionBHeight?.constant = buttonDimSmall
        optionBWidth?.constant = buttonDimSmall
        optionB.setNeedsLayout()
      case optionC:
        optionCHeight?.constant = buttonDimSmall
        optionCWidth?.constant = buttonDimSmall
        optionC.setNeedsLayout()
      default:
        print("active button is unknown")
      }
    }

    switch sender {
    case optionA:
      optionAHeight?.constant = buttonDimBig
      optionAWidth?.constant = buttonDimBig
      optionA.setNeedsLayout()
    case optionB:
      optionBHeight?.constant = buttonDimBig
      optionBWidth?.constant = buttonDimBig
      optionB.setNeedsLayout()
    case optionC:
      optionCHeight?.constant = buttonDimBig
      optionCWidth?.constant = buttonDimBig
      optionC.setNeedsLayout()
    default:
      print("sender button is unknown")
    }

    activeButton = sender

    UIView.animate(withDuration: 0.25, animations: {
      self.view.layoutIfNeeded()
    }) 
  }

  // MARK: - Setup & Layout

  fileprivate func setupSubviews() {
    optionA.backgroundColor = UIColor.white
    optionA.setTitle("A", for: UIControlState())
    optionA.addTarget(self, action: #selector(SimpleButtonExampleViewController.buttonPressed(_:)), for: .touchUpInside)
    view.addSubview(optionA)

    optionB.backgroundColor = UIColor.white
    optionB.setTitle("B", for: UIControlState())
    optionB.addTarget(self, action: #selector(SimpleButtonExampleViewController.buttonPressed(_:)), for: .touchUpInside)
    view.addSubview(optionB)

    optionC.backgroundColor = UIColor.white
    optionC.setTitle("C", for: UIControlState())
    optionC.addTarget(self, action: #selector(SimpleButtonExampleViewController.buttonPressed(_:)), for: .touchUpInside)
    view.addSubview(optionC)
  }

  fileprivate func setupLayout() {
    Manuscript.layout(optionA) { c in
      optionAHeight = c.set(.height, to:buttonDimSmall).constraint
      optionAWidth = c.set(.width, to:buttonDimSmall).constraint
      c.make(.right, equalTo:optionB, s:.left, minus: 10.0)
      c.make(.centerY, equalTo:view, s:.centerY)
    }

    Manuscript.layout(optionB) { c in
      optionBHeight = c.set(.height, to:buttonDimSmall).constraint
      optionBWidth = c.set(.width, to:buttonDimSmall).constraint
      c.centerIn(view)
    }

    Manuscript.layout(optionC) { c in
      optionCHeight = c.set(.height, to:buttonDimSmall).constraint
      optionCWidth = c.set(.width, to:buttonDimSmall).constraint
      c.make(.left, equalTo:optionB, s:.right, plus: 10.0)
      c.make(.centerY, equalTo:view, s:.centerY)
    }
  }

}
