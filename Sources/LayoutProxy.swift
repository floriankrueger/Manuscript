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

  /// The `LayoutProxy` is responsible for creating all the constraints.

  open class LayoutProxy: NSObject {
    
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
    
    open func setPriorityRequired() {
      self.internalPriority = 1000
    }
    
    /// Set the priority for all constraints created *after* this call to `750`
    
    open func setPriorityDefaultHigh() {
      self.internalPriority = 750
    }
    
    /// Set the priority for all constraints created *after* this call to `250`
    
    open func setPriorityDefaultLow() {
      self.internalPriority = 250
    }
    
    /// Set the priority for all constraints created *after* this call to `50`
    
    open func setPriorityFittingSizeLevel() {
      self.internalPriority = 50
    }
    
    /// Set the priority for all constraints created *after* this call to the given `priority`
    ///
    /// - parameter priority: A UILayoutPriority a.k.a. int between 0 and 1000
    
    open func setPriority(_ priority: UILayoutPriority) {
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
    /// - parameter identifier: optional identifier for debugging purposes
    ///
    /// - returns: a layout item whose target item is the view itself
    
    @discardableResult open func set(_ attribute: NSLayoutAttribute, to constant: CGFloat, identifier: String? = nil) -> LayoutItem {
      return self.set(self.view, attribute: attribute, relation: .equal, constant: constant, priority: self.internalPriority, identifier: identifier)
    }
    
    /// Set a layout attribute to a specific constant using a `greaterThan` relation. This is mostly
    /// used for width and height. Constraints created by 'set' methods are always added to the
    /// view itself so that `c.view == layoutItem.targetView`.
    ///
    /// - parameter attribute: the layout attribute to be set
    /// - parameter constant: the constant to be used for the constraint
    /// - parameter identifier: optional identifier for debugging purposes
    ///
    /// - returns: a layout item whose target item is the view itself
    
    @discardableResult open func set(_ attribute: NSLayoutAttribute, toMoreThan constant: CGFloat, identifier: String? = nil) -> LayoutItem {
      return self.set(self.view, attribute: attribute, relation: .greaterThanOrEqual, constant: constant, priority: self.internalPriority, identifier: identifier)
    }
    
    /// Set a layout attribute to a specific constant using a `lessThan` relation. This is mostly
    /// used for width and height. Constraints created by 'set' methods are always added to the
    /// view itself so that `c.view == layoutItem.targetView`.
    ///
    /// - parameter attribute: the layout attribute to be set
    /// - parameter constant: the constant to be used for the constraint
    /// - parameter identifier: optional identifier for debugging purposes
    ///
    /// - returns: a layout item whose target item is the view itself
    
    @discardableResult open func set(_ attribute: NSLayoutAttribute, toLessThan constant: CGFloat, identifier: String? = nil) -> LayoutItem {
      return self.set(self.view, attribute: attribute, relation: .lessThanOrEqual, constant: constant, priority: self.internalPriority, identifier: identifier)
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
    /// - parameter identifier: optional identifier for debugging purposes
    ///
    /// - returns: a layout item containing the created constraint as well as the target view on
    ///           which the constraint was installed
    
    @discardableResult open func make(_ attribute: NSLayoutAttribute, equalTo relatedItem: AnyObject, s relatedAttribute: NSLayoutAttribute, times multiplier: CGFloat = 1.0, plus constant: CGFloat = 0.0, minus negativeConstant: CGFloat = 0.0, on targetView: UIView? = nil, identifier: String? = nil) -> LayoutItem {
      return self.make(self.view, attribute: attribute, relation: .equal, relatedItem: relatedItem, relatedItemAttribute: relatedAttribute, multiplier: multiplier, constant: constant - negativeConstant, target: targetView, priority: self.internalPriority, identifier: identifier)
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
    /// - parameter identifier: optional identifier for debugging purposes
    ///
    /// - returns: a layout item containing the created constraint as well as the target view on
    ///           which the constraint was installed
    
    @discardableResult open func make(_ attribute: NSLayoutAttribute, greaterThan relatedItem: AnyObject, s relatedAttribute: NSLayoutAttribute, times multiplier: CGFloat = 1.0, plus constant: CGFloat = 0.0, minus negativeConstant: CGFloat = 0.0, on targetView: UIView? = nil, identifier: String? = nil) -> LayoutItem {
      return self.make(self.view, attribute: attribute, relation: .greaterThanOrEqual, relatedItem: relatedItem, relatedItemAttribute: relatedAttribute, multiplier: multiplier, constant: constant - negativeConstant, target: targetView, priority: self.internalPriority, identifier: identifier)
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
    /// - parameter identifier: optional identifier for debugging purposes
    ///
    /// - returns: a layout item containing the created constraint as well as the target view on
    ///           which the constraint was installed
    
    @discardableResult open func make(_ attribute: NSLayoutAttribute, lessThan relatedItem: AnyObject, s relatedAttribute: NSLayoutAttribute, times multiplier: CGFloat = 1.0, plus constant: CGFloat = 0.0, minus negativeConstant: CGFloat = 0.0, on targetView: UIView? = nil, identifier: String? = nil) -> LayoutItem {
      return self.make(self.view, attribute: attribute, relation: .lessThanOrEqual, relatedItem: relatedItem, relatedItemAttribute: relatedAttribute, multiplier: multiplier, constant: constant - negativeConstant, target: targetView, priority: self.internalPriority, identifier: identifier)
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
    /// - parameter identifier: optional identifier for debugging purposes. The four constraints that are created
    ///                     will ne labeled "<identifier>_left", "<identifier>_top", "<identifier>_right" and
    ///                     "<identifier>_bottom"
    ///
    /// - returns: an array of layout items in the order mentinoned above (left, top, right, bottom)
    
    @discardableResult open func alignAllEdges(to relatedItem: UIView, withInsets insets: UIEdgeInsets = UIEdgeInsets.zero, identifier: String? = nil) -> [LayoutItem] {
      var result: [LayoutItem] = []
      result.append(self.make(.left,    equalTo: relatedItem, s: .left,   plus:   insets.left,    identifier: Manuscript.suffixedIdFromId(identifier, suffix: "left")))
      result.append(self.make(.top,     equalTo: relatedItem, s: .top,    plus:   insets.top,     identifier: Manuscript.suffixedIdFromId(identifier, suffix: "top")))
      result.append(self.make(.right,   equalTo: relatedItem, s: .right,  minus:  insets.right,   identifier: Manuscript.suffixedIdFromId(identifier, suffix: "right")))
      result.append(self.make(.bottom,  equalTo: relatedItem, s: .bottom, minus:  insets.bottom,  identifier: Manuscript.suffixedIdFromId(identifier, suffix: "bottom")))
      return result
    }
    
    /// Align both vertical and horizontal centers to the related item. This creates two
    /// constraints:
    ///
    /// * center x to center x
    /// * center y to center y
    ///
    /// - parameter view: the view to be centered in
    /// - parameter identifier: optional identifier for debugging purposes. The two constraints that are created
    ///                     will ne labeled "<identifier>_center_x" and "<identifier>_center_y"
    ///
    /// - returns: an array of layout items in the order mentinoned above (center x, center y)
    
    @discardableResult open func centerIn(_ view: UIView, identifier: String? = nil) -> [LayoutItem] {
      var result: [LayoutItem] = []
      result.append(self.make(.centerX, equalTo: view, s: .centerX, identifier: Manuscript.suffixedIdFromId(identifier, suffix: "center_x")))
      result.append(self.make(.centerY, equalTo: view, s: .centerY, identifier: Manuscript.suffixedIdFromId(identifier, suffix: "center_y")))
      return result
    }
    
    /// Set both width and height at once. This creates two constraints on the view itself:
    ///
    /// * width equal to `size.width`
    /// * height equal to `size.height`
    ///
    /// - parameter size: the desired size of the view
    /// - parameter identifier: optional identifier for debugging purposes. The two constraints that are created
    ///                     will ne labeled "<identifier>_height" and "<identifier>_width"
    ///
    /// - returns: an array of layout items in the order mentioned above (width, height)
    
    @discardableResult open func setSize(_ size: CGSize, identifier: String? = nil) -> [LayoutItem] {
      var result: [LayoutItem] = []
      result.append(self.set(.height, to: size.height,  identifier: Manuscript.suffixedIdFromId(identifier, suffix: "height")))
      result.append(self.set(.width, to: size.width,    identifier: Manuscript.suffixedIdFromId(identifier, suffix: "width")))
      return result
    }
    
    /// Helper method to create a vertical (top to bottom) hairline, resolution independent. This
    /// will create a single constraint on the view itself:
    ///
    /// * width equal to 1.0 on non-retina displays, 0.5 on retina displays
    ///
    /// - parameter identifier: optional identifier for debugging purposes
    ///
    /// - returns: a single layout item
    
    @discardableResult open func makeVerticalHairline(_ identifier: String? = nil) -> LayoutItem {
      if self.utils.isRetina() {
        return self.set(.width, to: 0.5, identifier: identifier)
      }
      return self.set(.width, to: 1.0, identifier: identifier)
    }
    
    /// Helper method to create a horizontal (left to right) hairline, resolution independent. This
    /// will create a single constraint on the view itself:
    ///
    /// * height equal to 1.0 on non-retina displays, 0.5 on retina displays
    ///
    /// - parameter identifier: optional identifier for debugging purposes
    ///
    /// - returns: a single layout item
    
    @discardableResult open func makeHorizontalHairline(_ identifier: String? = nil) -> LayoutItem {
      if self.utils.isRetina() {
        return self.set(.height, to: 0.5, identifier: identifier)
      }
      return self.set(.height, to: 1.0, identifier: identifier)
    }
    
    // MARK: Core
    
    fileprivate func set(_ item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, constant: CGFloat, priority: UILayoutPriority, identifier: String?) -> LayoutItem {
      return self.createLayoutConstraint(item, attribute: attribute, relation: relation, relatedItem: nil, relatedItemAttribute: .notAnAttribute, multiplier: 1.0, constant: constant, target: item, priority: priority, identifier: identifier)
    }
    
    fileprivate func make(_ item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedItem: AnyObject, relatedItemAttribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat, target: UIView?, priority: UILayoutPriority, identifier: String?) -> LayoutItem {
      return self.createLayoutConstraint(item, attribute: attribute, relation: relation, relatedItem: relatedItem, relatedItemAttribute: relatedItemAttribute, multiplier: multiplier, constant: constant, target: target, priority: priority, identifier: identifier)
    }
    
    fileprivate func createLayoutConstraint(_ item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, relatedItem: AnyObject?, relatedItemAttribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat, target aTarget: UIView?, priority: UILayoutPriority, identifier: String?) -> LayoutItem {
      
      let constraint = NSLayoutConstraint(
        item: item,
        attribute: attribute,
        relatedBy: relation,
        toItem: relatedItem,
        attribute: relatedItemAttribute,
        multiplier: multiplier,
        constant: constant)
      
      constraint.priority = priority
      constraint.identifier = identifier ?? Manuscript.defaultIdentifier
      
      if let target = aTarget {
        return self.installConstraint(constraint, onTarget: target)
      }
      
      if #available(iOS 9.0, *) {
        return self.iOS9_installConstraint(item, relatedItem: relatedItem, constraint: constraint)
      } else {
        return self.earlier_installConstraint(item, relatedItem: relatedItem, constraint: constraint)
      }
    }
    
    fileprivate func iOS9_installConstraint(_ item: UIView, relatedItem: AnyObject?, constraint: NSLayoutConstraint) -> LayoutItem {
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
    
    fileprivate func earlier_installConstraint(_ item: UIView, relatedItem: AnyObject?, constraint: NSLayoutConstraint) -> LayoutItem {
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
    
    fileprivate func installConstraint(_ constraint: NSLayoutConstraint, onTarget target: UIView) -> LayoutItem {
      target.addConstraint(constraint)
      return (constraint, target)
    }
  }
}
