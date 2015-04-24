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

public struct Manuscript {

  public static func layout(view: UIView, block: (LayoutProxy) -> ()) -> Manuscript.LayoutProxy {
    let layoutProxy = LayoutProxy(view: view)
    block(layoutProxy)
    return layoutProxy
  }

  static func findCommonSuperview(a: UIView, b: UIView?) -> UIView? {

    if let b = b {

      // Quick-check the most likely possibilities
      let (aSuper, bSuper) = (a.superview, b.superview)
      if a == bSuper { return a }
      if b == aSuper { return b }
      if aSuper == bSuper { return aSuper }

      // None of those; run the general algorithm
      var ancestorsOfA = NSSet(array: Array(ancestors(a)))
      for ancestor in ancestors(b) {
        if ancestorsOfA.containsObject(ancestor) {
          return ancestor
        }
      }
      return nil // No ancestors in common
    }

    return a // b is nil
  }

  static func ancestors(v: UIView) -> SequenceOf<UIView> {
    return SequenceOf<UIView> { () -> GeneratorOf<UIView> in
      var view: UIView? = v
      return GeneratorOf {
        let current = view
        view = view?.superview
        return current
      }
    }
  }

  struct Util {
    static func isRetina() -> Bool {
      return UIScreen.mainScreen().scale > 1.0
    }
  }

}
