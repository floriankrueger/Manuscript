//
//  SimpleButtonExampleViewController.swift
//  Example
//
//  Created by Florian Krüger on 25/04/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//

import UIKit

class SimpleButtonExampleViewController: UIViewController {

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

    self.view.backgroundColor = UIColor.whiteColor()

    self.setupSubviews()
    self.setupLayout()
  }

  // MARK: - Setup & Layout

  private func setupSubviews() {

  }

  private func setupLayout() {

  }

}
