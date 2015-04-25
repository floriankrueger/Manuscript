//
//  SimpleButtonExampleViewController.swift
//  Example
//
//  Created by Florian Krüger on 25/04/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//

import UIKit
import Manuscript

class SimpleButtonExampleViewController: UIViewController {

  // MARK: Private Properties

  private let activeButton: UIButton? = nil

  private let optionA: UIButton = UIButton.buttonWithType(.System) as! UIButton
  private let optionB: UIButton = UIButton.buttonWithType(.System) as! UIButton
  private let optionC: UIButton = UIButton.buttonWithType(.System) as! UIButton

  private var optionAHeight: NSLayoutConstraint? = nil
  private var optionAWidth: NSLayoutConstraint? = nil
  private var optionBHeight: NSLayoutConstraint? = nil
  private var optionBWidth: NSLayoutConstraint? = nil
  private var optionCHeight: NSLayoutConstraint? = nil
  private var optionCWidth: NSLayoutConstraint? = nil

  // MARK: - Init

  init() {
    super.init(nibName: nil, bundle: nil)
    self.title = "Buttons"
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }

  // MARK: - View

  override func loadView() {
    super.loadView()

    self.view.backgroundColor = UIColor.grayColor()

    self.setupSubviews()
    self.setupLayout()
  }

  // MARK: - Target

  func buttonPressed(sender: UIButton) {
    if sender == self.activeButton {
      return;
    }

    if let activeButton = self.activeButton {
      self.shrinkButton(activeButton)
    }
  }

  // MARK: - Setup & Layout

  private func setupSubviews() {
    self.optionA.backgroundColor = UIColor.whiteColor()
    self.optionA.setTitle("A", forState: .Normal)
    self.optionA.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
    self.view.addSubview(self.optionA)

    self.optionB.backgroundColor = UIColor.whiteColor()
    self.optionB.setTitle("B", forState: .Normal)
    self.optionB.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
    self.view.addSubview(self.optionB)

    self.optionC.backgroundColor = UIColor.whiteColor()
    self.optionC.setTitle("C", forState: .Normal)
    self.optionC.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
    self.view.addSubview(self.optionC)
  }

  private func setupLayout() {
    Manuscript.layout(self.optionA) { c in
      self.optionAHeight = c.set(.Height, to:60.0).constraint
      self.optionAWidth = c.set(.Width, to:60.0).constraint
      c.make(.Right, equalTo:self.optionB, s:.Left, minus: 10.0)
      c.make(.CenterY, equalTo:self.view, s:.CenterY)
    }

    Manuscript.layout(self.optionB) { c in
      self.optionBHeight = c.set(.Height, to:60.0).constraint
      self.optionBWidth = c.set(.Width, to:60.0).constraint
      c.centerIn(self.view)
    }

    Manuscript.layout(self.optionC) { c in
      self.optionCHeight = c.set(.Height, to:60.0).constraint
      self.optionCWidth = c.set(.Width, to:60.0).constraint
      c.make(.Left, equalTo:self.optionB, s:.Right, plus: 10.0)
      c.make(.CenterY, equalTo:self.view, s:.CenterY)
    }
  }

}
