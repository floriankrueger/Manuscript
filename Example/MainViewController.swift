//
//  MainViewController.swift
//  Example
//
//  Created by Florian Krüger on 24/04/15.
//  Copyright (c) 2015 projectserver.org. All rights reserved.
//

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

  private let tableView = UITableView(frame: CGRectZero, style: .Plain)
  private let menuItems: [Int:MainMenuItem] = [
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

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    if let selectedIndexPath = self.tableView.indexPathForSelectedRow() {
      self.tableView.deselectRowAtIndexPath(selectedIndexPath, animated: animated)
    }
  }

  // MARK: - UITableViewDelegate

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let menuItem = menuItems[indexPath.row] {
      self.navigationController?.pushViewController(menuItem.createController(), animated: true)
    }
  }

  // MARK: - UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.menuItems.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier(menuItemCellIdentifier) as? UITableViewCell {
      if let menuItem = menuItems[indexPath.row] {
        cell.textLabel?.text = menuItem.title
        cell.accessoryType = .DisclosureIndicator
      }
      return cell
    }
    fatalError("no cell dequeued for identifier '\(menuItemCellIdentifier)'")
  }

  // MARK: - Setup & Layout

  private func setupSubviews() {
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: menuItemCellIdentifier)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.view.addSubview(self.tableView)
  }

  private func setupLayout() {
    Manuscript.layout(self.tableView) { c in
      c.alignAllEdges(to: self.view)
    }
  }
  
}
