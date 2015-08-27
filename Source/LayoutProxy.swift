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

  /// A Manuscript `LayoutItem` consists of two things:
  ///
  /// * the `constraint` that was generated through Manuscript
  /// * the `targetItem` on which the constraint was installed. That is the nearest ancestor view
  ///   of the views that are referenced by the constraint.

  public typealias LayoutItem = (constraint: NSLayoutConstraint, targetItem: UIView)

  /// The `LayoutProxy` is responsible for creating all the constraints.

  public class LayoutProxy: NSObject {

    let view: UIView
    let utils: ManuscriptUtils
    var internalPriority: UILayoutPriority

    init(view: UIView, utils:ManuscriptUtils) {
      self.view = view
      self.view.translatesAutoresizingMaskIntoConstraints = false
      self.internalPriority = 1000
      self.utils = utils
      super.init()
    }

    // MARK: Priority

    /// Set the priority for all constraints created *after* this call to `1000`

    public func setPriorityRequired() {
      self.internalPriority = 1000
    }

    /// Set the priority for all constraints created *after* this call to `750`

    public func setPriorityDefaultHigh() {
      self.internalPriority = 750
    }

    /// Set the priority for all constraints created *after* this call to `250`

    public func setPriorityDefaultLow() {
      self.internalPriority = 250
    }

    /// Set the priority for all constraints created *after* this call to `50`

    public func setPriorityFittingSizeLevel() {
      self.internalPriority = 50
    }

    /// Set the priority for all constraints created *after* this call to the given `priority`
    ///
    /// - parameter priority: A UILayoutPriority a.k.a. int between 0 and 1000

    public func setPriority(priority: UILayoutPriority) {
      if priority > 1000 {
        self.internalPriority = 1000
        print("UILayoutPriority only supports values between 1 and 1000. Setting to 1000 (while trying to set the priority to \(priority)).")
      } else if priority <= 0 {
        self.internalPriority = 1
        print("UILayoutPriority only supports values between 1 and 1000. Setting to 1 (while trying to set the priority to \(priority)).")
      } else {
        self.internalPriority = priority
      }
    }

    // MARK: DSL (set)

    /// Set a layout attribute to a specific constant using a `equalTo` relation. This is mostly
    /// used for width and height. Constraints created by 'set' methods are always added to the
    /// view itself so that `c.view == layoutItem.targetView`.
    ///
    /// - parameter attribute: the layout attribute to be set
    /// - parameter constant: the constant to be used for the constraint
    ///
    /// - returns: a layout item whose target item is the view itself

    public func set(attribute: NSLayoutAttribute, to constant: CGFloat) -> LayoutItem {
      return self.set(self.view, attribute: attribute, relation: .Equal, constant: constant, priority: self.internalPriority)
    }

    /// Set a layout attribute to a specific constant using a `greaterThan` relation. This is mostly
    /// used for width and height. Constraints created by 'set' methods are always added to the
    /// view itself so that `c.view == layoutItem.targetView`.
    ///
    /// - parameter attribute: the layout attribute to be set
    /// - parameter constant: the constant to be used for the constraint
    ///
    /// - returns: a layout item whose target item is the view itself

    public func set(attribute: NSLayoutAttribute, toMoreThan constant: CGFloat) -> LayoutItem {
      return self.set(self.view, attribute: attribute, relation: .GreaterThanOrEqual, constant: constant, priority: self.internalPriority)
    }

    /// Set a layout attribute to a specific constant using a `lessThan` relation. This is mostly
    /// used for width and height. Constraints created by 'set' methods are always added to the
    /// view itself so that `c.view == layoutItem.targetView`.
    ///
    /// - parameter attribute: the layout attribute to be set
    /// - parameter constant: the constant to be used for the constraint
    ///
    /// - returns: a layout item whose target item is the view itself

    public func set(attribute: NSLayoutAttribute, toLessThan constant: CGFloat) -> LayoutItem {
      return self.set(self.view, attribute: attribute, relation: .LessThanOrEqual, constant: constant, priority: self.internalPriority)
    }

    // MARK: DSL (make)

    /// Align a given attribute to another views attributes using a `equalTo` relation.
    ///
    /// - parameter attribute: the attribute on the layout proxies’ view
    /// - parameter relatedItem: the item (view or layout guide) to relate to
    /// - parameter relatedAttribute: the attribute on the related item
    /// - parameter multiplier: a multiplier that is applied to the constraint
    /// - parameter constant: a constant that is added to the constant of the constraint
    /// - parameter negativeConstant: a constant that is subtracted from the constant of the constraint
    /// - parameter targetView: the view on which the constraint should be installed. you should normally
    ///                    not need to specify this. When this is `nil`, Manuscript looks for the
    ///                    closest common ancestor view of the two views under operation and
    ///                    installs the constraint there.
    ///
    /// - returns: a layout item containing the created constraint as well as the target view on
    ///           which the constraint was installed

    public func make(attribute: NSLayoutAttribute, equalTo relatedItem: AnyObject, s relatedAttribute: NSLayoutAttribute, times multiplier: CGFloat = 1.0, plus constant: CGFloat = 0.0, minus negativeConstant: CGFloat = 0.0, on targetView: UIView? = nil) -> LayoutItem {
      return self.make(self.view, attribute: attribute, relation: .Equal, relatedItem: relatedItem, relatedItemAttribute: relatedAttribute, multiplier: multiplier, constant: constant - negativeConstant, target: targetView, priority: self.internalPriority)
    }

    /// Align a given attribute to another views attributes using a `greaterThan` relation.
    ///
    /// - parameter attribute: the attribute on the layout proxies’ view
    /// - parameter relatedItem: the item (view or layout guide) to relate to
    /// - parameter relatedAttribute: the attribute on the related item
    /// - parameter multiplier: a multiplier that is applied to the constraint
    /// - parameter constant: a constant that is added to the constant of the constraint
    /// - parameter negativeConstant: a constant that is subtracted from the constant of the constraint
    /// - parameter targetView: the view on which the constraint should be installed. you should normally
    ///                    not need to specify this. When this is `nil`, Manuscript looks for the
    ///                    closest common ancestor view of the two views under operation and
    ///                    installs the constraint there.
    ///
    /// - returns: a layout item containing the created constraint as well as the target view on
    ///           which the constraint was installed

    public func make(attribute: NSLayoutAttribute, greaterThan relatedItem: AnyObject, s relatedAttribute: NSLayoutAttribute, times multiplier: CGFloat = 1.0, plus constant: CGFloat = 0.0, minus negativeConstant: CGFloat = 0.0, on targetView: UIView? = nil) -> LayoutItem {
      return self.make(self.view, attribute: attribute, relation: .GreaterThanOrEqual, relatedItem: relatedItem, relatedItemAttribute: relatedAttribute, multiplier: multiplier, constant: constant - negativeConstant, target: targetView, priority: self.internalPriority)
    }

    /// Align a given attribute to another views attributes using a `lessThan` relation.
    ///
    /// - parameter attribute: the attribute on the layout proxies’ view
    /// - parameter relatedItem: the item (view or layout guide) to relate to
    /// - parameter relatedAttribute: the attribute on the related item
    /// - parameter multiplier: a multiplier that is applied to the constraint
    /// - parameter constant: a constant that is added to the constant of the constraint
    /// - parameter negativeConstant: a constant that is subtracted from the constant of the constraint
    /// - parameter targetView: the view on which the constraint should be installed. you should normally
    ///                    not need to specify this. When this is `nil`, Manuscript looks for the
    ///                    closest common ancestor view of the two views under operation and
    ///                    installs the constraint there.
    ///
    /// - returns: a layout item containing the created constraint as well as the target view on
    ///           which the constraint was installed

    public func make(attribute: NSLayoutAttribute, lessThan relatedItem: AnyObject, s relatedAttribute: NSLayoutAttribute, times multiplier: CGFloat = 1.0, plus constant: CGFloat = 0.0, minus negativeConstant: CGFloat = 0.0, on targetView: UIView? = nil) -> LayoutItem {
      return self.make(self.view, attribute: attribute, relation: .LessThanOrEqual, relatedItem: relatedItem, relatedItemAttribute: relatedAttribute, multiplier: multiplier, constant: constant - negativeConstant, target: targetView, priority: self.internalPriority)
    }

    // MARK: DSL (convenience)

    /// Align all edges of the view under operation to the related view. This creates four
    /// constraints:
    ///
    /// * left to left plus insets.left
    /// * top to top plus insets.top
    /// * right to right minus insets.right
    /// * bottom to bottom minus insets.bottom
    ///
    /// - parameter relatedItem: the item to relate to
    /// - parameter insets: the insets to use for the constraints, zero by default
    ///
    /// - returns: an array of layout items in the order mentinoned above (left, top, right, bottom)

    public func alignAllEdges(to relatedItem: UIView, withInsets insets: UIEdgeInsets = UIEdgeInsetsZero) -> [LayoutItem] {
      var result: [LayoutItem] = []
      result.append(self.make(.Left,    equalTo: relatedItem, s: .Left,   plus:   insets.left))
      result.append(self.make(.Top,     equalTo: relatedItem, s: .Top,    plus:   insets.top))
      result.append(self.make(.Right,   equalTo: relatedItem, s: .Right,  minus:  insets.right))
      result.append(self.make(.Bottom,  equalTo: relatedItem, s: .Bottom, minus:  insets.bottom))
      return result
    }

    /// Align both vertical and horizontal centers to the related item. This creates two
    /// constraints:
    ///
    /// * center x to center x
    /// * center y to center y
    ///
    /// - parameter view: the view to be centered in
    ///
    /// - returns: an array of layout items in the order mentinoned above (center x, center y)

    public func centerIn(view: UIView) -> [LayoutItem] {
      var result: [LayoutItem] = []
      result.append(self.make(.CenterX, equalTo: view, s: .CenterX))
      result.append(self.make(.CenterY, equalTo: view, s: .CenterY))
      return result
    }

    /// Set both width and height at once. This creates two constraints on the view itself:
    ///
    /// * width equal to `size.width`
    /// * height equal to `size.height`
    ///
    /// - parameter size: the desired size of the view
    ///
    /// - returns: an array of layout items in the order mentioned above (width, height)

    public func setSize(size: CGSize) -> [LayoutItem] {
      var result: [LayoutItem] = []
      result.append(self.set(.Height, to: size.height))
      result.append(self.set(.Width, to: size.width))
      return result
    }

    /// Helper method to create a vertical (top to bottom) hairline, resolution independent. This
    /// will create a single constraint on the view itself:
    ///
    /// * width equal to 1.0 on non-retina displays, 0.5 on retina displays
    ///
    /// - returns: a single layout item

    public func makeVerticalHairline() -> LayoutItem {
      if self.utils.isRetina() {
        return self.set(.Width, to: 0.5)
      } else {
        return self.set(.Width, to: 1.0)
      }
    }

    /// Helper method to create a horizontal (left to right) hairline, resolution independent. This
    /// will create a single constraint on the view itself:
    ///
    /// * height equal to 1.0 on non-retina displays, 0.5 on retina displays
    ///
    /// - returns: a single layout item

    public func makeHorizontalHairline() -> LayoutItem {
      if self.utils.isRetina() {
        return self.set(.Height, to: 0.5)
      } else {
        return self.set(.Height, to: 1.0)
      }
    }

    // MARK: Core

    private func set(item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, constant: CGFloat, priority: UILayoutPriority) -> LayoutItem {
      return self.createLayoutConstraint(item, attribute: attribute, relation: relation, relatedItem: nil, relatedItemAttribute: .NotAnAttribute, multiplier: 1.0, constant: constant, target: item, priority: priority)
    }

    private func make(item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedItem: AnyObject, relatedItemAttribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat, target: UIView?, priority: UILayoutPriority) -> LayoutItem {
      return self.createLayoutConstraint(item, attribute: attribute, relation: relation, relatedItem: relatedItem, relatedItemAttribute: relatedItemAttribute, multiplier: multiplier, constant: constant, target: target, priority: priority)
    }

    private func createLayoutConstraint(item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedItem: AnyObject?, relatedItemAttribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat, target aTarget: UIView?, priority: UILayoutPriority) -> LayoutItem {

      let constraint = NSLayoutConstraint(
        item: item,
        attribute: attribute,
        relatedBy: relation,
        toItem: relatedItem,
        attribute: relatedItemAttribute,
        multiplier: multiplier,
        constant: constant)

      constraint.priority = priority

      if let target = aTarget {
        return self.installConstraint(constraint, onTarget: target)
      }

      if #available(iOS 9.0, *) {
        return self.iOS9_installConstraint(item: item, relatedItem: relatedItem, constraint: constraint)
      } else {
        return self.earlier_installConstraint(item: item, relatedItem: relatedItem, constraint: constraint)
      }
    }

    private func iOS9_installConstraint(item item: UIView, relatedItem: AnyObject?, constraint: NSLayoutConstraint) -> LayoutItem {
      if #available(iOS 9.0, *) {
          switch relatedItem {
          case let relatedView as UIView:
            if let target = Manuscript.findCommonSuperview(item, b: relatedView) {
              return self.installConstraint(constraint, onTarget: target)
            } else {
              fatalError("couldn't find common ancestors for \(item) and \(relatedView) (while trying to install \(constraint))")
            }
          case let relatedLayoutGuide as UILayoutGuide:
            if let target = Manuscript.findCommonSuperview(item, b: relatedLayoutGuide.owningView) {
              return self.installConstraint(constraint, onTarget: target)
            } else {
              fatalError("couldn't find common ancestors for \(item) and \(relatedLayoutGuide) (while trying to install \(constraint))")
            }
          default:
            fatalError("the type of relatedItem is (currently) unsupported. If you think it should be, please file an issue on github.")
          }
      } else {
          fatalError("the method `iOS9_installConstraint` does only work on iOS versions 9.0 and up. Don't call it directly.")
      }
    }

    private func earlier_installConstraint(item item: UIView, relatedItem: AnyObject?, constraint: NSLayoutConstraint) -> LayoutItem {
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
