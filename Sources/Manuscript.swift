//
//  Manuscript.swift
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

/// This is `Manuscript`. You should only need to interact with this part of the framework directly.
///
/// Usage:
///
/// ```
/// Manuscript.layout(<your view>) { c in
///   // create your constraints here
/// }
/// ```
///
/// See `Manuscript.layout` for more details

public struct Manuscript {

  /// The identifier that is set on all created constraints if the user doesn't provide an 
  /// identifier. This serves at least the purpose that the user is aware which constraints are 
  /// created by Manuscript.
  
  public static let defaultIdentifier = "MNSCRPT"
  
  /// Use this to define your AutoLayout constraints in your code.
  ///
  /// - parameter view: the `UIView` that should be layouted
  /// - parameter utils: an instance of `ManuscriptUtils`, you can ignore this parameter.
  /// - parameter block: a block that is provided with a `LayoutProxy` that is already setup with the
  ///              given `view`. You can create AutoLayout constraints through this proxy.
  ///
  /// - returns: the `LayoutProxy` instance that is also handed to the `block`
  
  @discardableResult public static func layout(_ view: UIView,
                                               utils: ManuscriptUtils = Utils(),
                                               block: (LayoutProxy) -> ()
    ) -> Manuscript.LayoutProxy
  {
    let layoutProxy = LayoutProxy(view: view, utils: utils)
    block(layoutProxy)
    return layoutProxy
  }
  
  /// Use this to define your AutoLayout constraints in your code.
  ///
  /// - parameter view: the `UIView` that should be layouted
  /// - parameter items: an `inout` that is populated with all created `LayoutItem`s. 
  ///   The array is emptied before the items are added, so store any still needed contents 
  ///   separately before passing the array in.
  /// - parameter utils: an instance of `ManuscriptUtils`, you can ignore this parameter.
  /// - parameter block: a block that is provided with a `LayoutProxy` that is already setup with the
  ///              given `view`. You can create AutoLayout constraints through this proxy.
  
  public static func layout(_ view: UIView,
                            _ items: inout [LayoutItem],
                            utils: ManuscriptUtils = Utils(),
                            block: (LayoutProxy) -> ()
    )
  {
    let layoutProxy = LayoutProxy(view: view, utils: utils)
    block(layoutProxy)
    items.removeAll()
    items.append(contentsOf: layoutProxy.items)
  }

  static func findCommonSuperview(_ a: UIView, b: UIView?) -> UIView? {

    if let b = b {

      // Quick-check the most likely possibilities
      let (aSuper, bSuper) = (a.superview, b.superview)
      if a == bSuper { return a }
      if b == aSuper { return b }
      if aSuper == bSuper { return aSuper }

      // None of those; run the general algorithm
      let ancestorsOfA = NSSet(array: Array(ancestors(a)))
      for ancestor in ancestors(b) {
        if ancestorsOfA.contains(ancestor) {
          return ancestor
        }
      }
      return nil // No ancestors in common
    }

    return a // b is nil
  }

  static func ancestors(_ v: UIView) -> AnySequence<UIView> {
    return AnySequence { () -> AnyIterator<UIView> in
      var view: UIView? = v
      return AnyIterator {
        let current = view
        view = view?.superview
        return current
      }
    }
  }

  struct Utils: ManuscriptUtils {
    func isRetina() -> Bool {
      return UIScreen.main.scale > 1.0
    }
  }

  static func suffixedIdFromId(_ identifier: String?, suffix: String) -> String {
    let id = identifier ?? Manuscript.defaultIdentifier
    return "\(id)_\(suffix)"
  }
}
