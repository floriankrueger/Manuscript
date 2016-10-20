//
//  MainViewController.swift
//  Example
//
//  Created by Florian Krüger on 24/04/15.
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

let menuItemCellIdentifier = "org.projectserver.Example.cell.mainMenuItem"

typealias CreateController = () -> UIViewController

struct MainMenuItem {
  var title: String
  var createController: CreateController
  var cellIdentifier: String
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  // MARK: Private Properties

  fileprivate let tableView = UITableView(frame: CGRect.zero, style: .plain)
  fileprivate let menuItems: [Int:MainMenuItem] = [
    0:MainMenuItem(
      title: "Simple Button Example",
      createController: { return SimpleButtonExampleViewController() },
      cellIdentifier: menuItemCellIdentifier)
  ]

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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
      self.tableView.deselectRow(at: selectedIndexPath, animated: animated)
    }
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let menuItem = menuItems[(indexPath as NSIndexPath).row] {
      self.navigationController?.pushViewController(menuItem.createController(), animated: true)
    }
  }

  // MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.menuItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: menuItemCellIdentifier) {
      if let menuItem = menuItems[(indexPath as NSIndexPath).row] {
        cell.textLabel?.text = menuItem.title
        cell.accessoryType = .disclosureIndicator
      }
      return cell
    }
    fatalError("no cell dequeued for identifier '\(menuItemCellIdentifier)'")
  }

  // MARK: - Setup & Layout

  fileprivate func setupSubviews() {
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: menuItemCellIdentifier)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.view.addSubview(self.tableView)
  }

  fileprivate func setupLayout() {
    Manuscript.layout(self.tableView) { c in
      c.alignAllEdges(to: self.view)
    }
  }
  
}
