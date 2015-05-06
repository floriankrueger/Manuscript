//
//  LayoutProxy.swift
//  Manuscript
//
//  Created by Florian Krüger on 17/11/14.
//  Copyright (c) 2014 projectserver.org. All rights reserved.
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

import Foundation
import UIKit

extension Manuscript {

  public typealias LayoutItem = (constraint: NSLayoutConstraint, targetItem: UIView)

  public class LayoutProxy: NSObject {

    let view: UIView
    var internalPriority: UILayoutPriority

    init(view: UIView) {
      self.view = view
      self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.internalPriority = 1000
      super.init()
    }

    // MARK: Priority

    public func setPriorityRequired() {
      self.internalPriority = 1000
    }

    public func setPriorityDefaultHigh() {
      self.internalPriority = 750
    }

    public func setPriorityDefaultLow() {
      self.internalPriority = 250
    }

    public func setPriorityFittingSizeLevel() {
      self.internalPriority = 50
    }

    public func setPriority(priority: UILayoutPriority) {
      if priority > 1000 {
        self.internalPriority = 1000
        println("UILayoutPriority only supports values between 1 and 1000. Setting to 1000 (while trying to set the priority to \(priority)).")
      } else if priority <= 0 {
        self.internalPriority = 1
        println("UILayoutPriority only supports values between 1 and 1000. Setting to 1 (while trying to set the priority to \(priority)).")
      } else {
        self.internalPriority = priority
      }
    }

    // MARK: DSL (set)

    public func set(attribute: NSLayoutAttribute, to constant: Float) -> LayoutItem {
      return self.set(self.view, attribute: attribute, relation: .Equal, constant: constant, priority: self.internalPriority)
    }

    public func set(attribute: NSLayoutAttribute, toMoreThan constant: Float) -> LayoutItem {
      return self.set(self.view, attribute: attribute, relation: .GreaterThanOrEqual, constant: constant, priority: self.internalPriority)
    }

    public func set(attribute: NSLayoutAttribute, toLessThan constant: Float) -> LayoutItem {
      return self.set(self.view, attribute: attribute, relation: .LessThanOrEqual, constant: constant, priority: self.internalPriority)
    }

    // MARK: DSL (make)

    public func make(attribute: NSLayoutAttribute, equalTo relatedItem: AnyObject, s relatedAttribute: NSLayoutAttribute, times multiplier: Float = 1.0, plus constant: Float = 0.0, minus negativeConstant: Float = 0.0, on targetView: UIView? = nil) -> LayoutItem {
      return self.make(self.view, attribute: attribute, relation: .Equal, relatedItem: relatedItem, relatedItemAttribute: relatedAttribute, multiplier: multiplier, constant: constant - negativeConstant, target: targetView, priority: self.internalPriority)
    }

    public func make(attribute: NSLayoutAttribute, greaterThan relatedItem: AnyObject, s relatedAttribute: NSLayoutAttribute, times multiplier: Float = 1.0, plus constant: Float = 0.0, minus negativeConstant: Float = 0.0, on targetView: UIView? = nil) -> LayoutItem {
      return self.make(self.view, attribute: attribute, relation: .GreaterThanOrEqual, relatedItem: relatedItem, relatedItemAttribute: relatedAttribute, multiplier: multiplier, constant: constant - negativeConstant, target: targetView, priority: self.internalPriority)
    }

    public func make(attribute: NSLayoutAttribute, lessThan relatedItem: AnyObject, s relatedAttribute: NSLayoutAttribute, times multiplier: Float = 1.0, plus constant: Float = 0.0, minus negativeConstant: Float = 0.0, on targetView: UIView? = nil) -> LayoutItem {
      return self.make(self.view, attribute: attribute, relation: .LessThanOrEqual, relatedItem: relatedItem, relatedItemAttribute: relatedAttribute, multiplier: multiplier, constant: constant - negativeConstant, target: targetView, priority: self.internalPriority)
    }

    // MARK: DSL (convenience)

    public func alignAllEdges(to relatedItem: UIView) -> [LayoutItem] {
      var result: [LayoutItem] = []
      result.append(self.make(.Left,    equalTo: relatedItem, s: .Left))
      result.append(self.make(.Top,     equalTo: relatedItem, s: .Top))
      result.append(self.make(.Right,   equalTo: relatedItem, s: .Right))
      result.append(self.make(.Bottom,  equalTo: relatedItem, s: .Bottom))
      return result
    }

    public func centerIn(view: UIView) -> [LayoutItem] {
      var result: [LayoutItem] = []
      result.append(self.make(.CenterX, equalTo: view, s: .CenterX))
      result.append(self.make(.CenterY, equalTo: view, s: .CenterY))
      return result
    }

    public func setSize(size: CGSize) -> [LayoutItem] {
      var result: [LayoutItem] = []
      result.append(self.set(.Height, to: Float(size.height)))
      result.append(self.set(.Width, to: Float(size.width)))
      return result
    }

    public func makeVerticalHairline() -> LayoutItem {
      if Manuscript.Util.isRetina() {
        return self.set(.Width, to: 0.5)
      } else {
        return self.set(.Width, to: 1.0)
      }
    }

    public func makeHorizontalHairline() -> LayoutItem {
      if Manuscript.Util.isRetina() {
        return self.set(.Height, to: 0.5)
      } else {
        return self.set(.Height, to: 1.0)
      }
    }

    // MARK: Core

    private func set(item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, constant: Float, priority: UILayoutPriority) -> LayoutItem {
      return self.createLayoutConstraint(item, attribute: attribute, relation: relation, relatedItem: nil, relatedItemAttribute: .NotAnAttribute, multiplier: 1.0, constant: constant, target: item, priority: priority)
    }

    private func make(item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedItem: AnyObject, relatedItemAttribute: NSLayoutAttribute, multiplier: Float, constant: Float, target: UIView?, priority: UILayoutPriority) -> LayoutItem {
      return self.createLayoutConstraint(item, attribute: attribute, relation: relation, relatedItem: relatedItem, relatedItemAttribute: relatedItemAttribute, multiplier: multiplier, constant: constant, target: target, priority: priority)
    }

    private func createLayoutConstraint(item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedItem: AnyObject?, relatedItemAttribute: NSLayoutAttribute, multiplier: Float, constant: Float, target aTarget: UIView?, priority: UILayoutPriority) -> LayoutItem {

      let constraint = NSLayoutConstraint(
        item: item,
        attribute: attribute,
        relatedBy: relation,
        toItem: relatedItem,
        attribute: relatedItemAttribute,
        multiplier: CGFloat(multiplier),
        constant: CGFloat(constant))

      constraint.priority = priority

      if let target = aTarget {
        return self.installConstraint(constraint, onTarget: target)
      }

      var relatedView: UIView? = nil
      if let aRelatedView = relatedItem as? UIView {
        relatedView = aRelatedView
      }

      if let target = Manuscript.findCommonSuperview(item, b: relatedView) {
        return self.installConstraint(constraint, onTarget: target)
      } else {
        fatalError("couldn't find common ancestors for \(item) and \(relatedView) (while trying to install \(constraint))")
      }
    }

    private func installConstraint(constraint: NSLayoutConstraint, onTarget target: UIView) -> LayoutItem {
      target.addConstraint(constraint)
      return (constraint, target)
    }
  }
}
