//
//  MainViewController.swift
//  Example
//
//  Created by Florian Krüger on 24/04/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//

import UIKit
import Manuscript

class MainViewController: UIViewController {

  // MARK: Private Properties

  private let tableView = UITableView(frame: CGRectZero, style: .Plain)

  // MARK: - Init

  init() {
    super.init(nibName: nil, bundle: nil)
    self.title = "Manuscript"
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }

  // MARK: - View

  override func loadView() {
    super.loadView()
    self.setupSubviews()
    self.setupLayout()
  }

  // MARK: - Setup & Layout

  private func setupSubviews() {
    self.view.addSubview(self.tableView)
  }

  private func setupLayout() {
    Manuscript.layout(self.tableView) { c in
      c.alignAllEdges(to: self.view)
    }
  }

}
