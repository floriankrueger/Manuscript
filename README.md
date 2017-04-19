[![CircleCI](https://img.shields.io/circleci/project/floriankrueger/Manuscript.svg)](https://circleci.com/gh/floriankrueger/Manuscript)
[![codebeat badge](https://codebeat.co/badges/f0466b34-3549-43df-b8a9-b01c41239ca3)](https://codebeat.co/projects/github-com-floriankrueger-manuscript-master)
[![GitHub release](https://img.shields.io/github/release/floriankrueger/Manuscript.svg)](https://github.com/floriankrueger/Manuscript)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Manuscript.svg)](https://github.com/floriankrueger/Manuscript)
[![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)](https://swift.org)
[![Gitmoji](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=flat)](https://gitmoji.carloscuesta.me)
 
![Manuscript: Dead-Simple AutoLayout](https://raw.githubusercontent.com/floriankrueger/Manuscript/assets/manuscript.png)

It's like [AutoLayoutKit](https://github.com/floriankrueger/AutoLayoutKit) but written in Swift.
For pure Swift projects. And it's super simple.

## Features

- [x] concise, simple and convenient API
- [x] raw AutoLayout power
- [x] no black magic involved
- [x] fully documented
- [x] completely unit-tested

Have a look at the [Changelog](CHANGELOG.md) for more details.

## Requirements

- iOS 8.0+
- Xcode 8.x
- Swift 3.1

### Bonus: Support for iOS 7.0+ and/or tvOS

Although the cocoapods isn't able to install Manuscript for your iOS 7.0+ app or for your tvOS app
(yet), you can use still Manuscript. Just follow the 'manual' installation or add Manuscript as a
framework project to your workspace (that's what I do).

## What it looks like

```swift
Manuscript.layout(myButton) { c in
  c.set(.Height, to: 60.0)
  c.set(.Width, to: 60.0)
  c.make(.Bottom, equalTo: self.view, s: .Bottom, minus: 10.0)
  c.make(.CenterX, equalTo: self.view, s: .CenterX)
}
```

## Usage

A few examples on how to use Manuscript.

### Center and set size

Center a UIView 'childView' in self.view and make it 30 by 30 in size

```swift
Manuscript.layout(childView) { c in
  c.make(.CenterX, equalTo: view, s: .CenterX)
  c.make(.CenterY, equalTo: view, s: .CenterY)
  c.set(.Width, to: 30.0)
  c.set(.Height, to: 30.0)
}
```

The same, but using the convenience methods

```swift
Manuscript.layout(childView) { c in
  c.centerIn(view)
  c.setSize(CGSize(width: 30.0, height: 30.0))
}
```

### Align all edges of a view to a superview

Align a UIView 'container' to all edges of self.view

```swift
Manuscript.layout(container) { c in
  c.make(.Left, equalTo: view, s: .Left)
  c.make(.Right, equalTo: view, s: .Right)
  c.make(.Top, equalTo: view, s: .Top)
  c.make(.Bottom, equalTo: view, s: .Bottom)
}
```

The same, but using the convenience methods

```swift
Manuscript.layout(container) { c in
  c.alignAllEdges(to: view)
}
```

### Align all sides with insets

Align a UIView 'container' to all edges of self.view and leave a 30 point margin around the
container.

```swift
Manuscript.layout(container) { c in
  c.make(.Left, equalTo: view, s: .Left, plus: 30.0)
  c.make(.Right, equalTo: view, s: .Right, minus: 30.0)
  c.make(.Top, equalTo: view, s: .Top, plus: 30.0)
  c.make(.Bottom, equalTo: view, s: .Bottom, minus: 30.0)
}
```

The same, but using convenience methods.

```swift
Manuscript.layout(container) { c in
  c.alignAllEdges(to: view, withInsets: UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 30.0))
}
```

### Use LayoutGuides

Make use of the LayoutGuides provided by UIViewController.

```swift
Manuscript.layout(container) { c in
  c.make(.Left, equalTo: view, s: .Left)
  c.make(.Right, equalTo: view, s: .Right)
  c.make(.Top, equalTo: topLayoutGuide, s: .Baseline)
  c.make(.Bottom, equalTo: bottomLayoutGuide, s: .Baseline)
}
```

### Hairlines

There is a utility method to create hairlines which takes the screen scale into account.

```swift
Manuscript.layout(mySeparatorLine) { c in
  c.make(.Left, equalTo: view, s: .Left)
  c.make(.Right, equalTo: view, s: .Right)
  c.make(.Top, equalTo: topLayoutGuide, s: .Baseline)

  // sets the .Height to 1.0 on non-retina displays and to 0.5 on retina displays
  c.makeHorizontalHairline()
}
```

### Work with the created Layout Constraints

The functions `make` and `set` return a tuple of type `LayoutItem` which translates to
`(constraint: NSLayoutConstraint?, targetItem: UIView?)`. The 'constraint' is the created
`NSLayoutConstraint`, the 'targetItem' is the view to which the `NSLayoutConstraint` was added. It
is the nearest common superview of the `UIView`s involved.

```swift
Manuscript.layout(container) { c in
  leftConstaint = c.make(.Left, equalTo: view, s: .Left).constraint
  rightConstaint = c.make(.Right, equalTo: view, s: .Right).constraint
  topConstaint = c.make(.Top, equalTo: topLayoutGuide, s: .Baseline).constraint
  bottomConstaint = c.make(.Bottom, equalTo: bottomLayoutGuide, s: .Baseline).constraint
}
```

Afterwards, just modify the constraint's constant and apply the changes (this is plain AutoLayout).

```swift
UIView.animateWithDuration(0.6) { in
  topConstraint?.constant = 100
  view.layoutIfNeeded()
}
```

### Convenience Methods

The convenience methods return arrays of the mentioned tuples. These will be dictionaries or tuples
in the future as well to provide easier access to the created constraints. Until then, check the
code for the order of the returned constraints.

## Installation

As for now, you can use [Carthage](https://github.com/Carthage/Carthage) or [CocoaPods](https://cocoapods.org) to install Manuscript
using a dependency manager or do it manually.

### Carthage

To integrate Manuscript into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "floriankrueger/Manuscript"
```

If you need to support Swift 2.3 then please use the last compatible version 2.1.0

```ogdl
github "floriankrueger/Manuscript" == 2.1.0
```
 
If you need to support Swift 3.0 then please use the last compatible version 3.0.1
 
```ogdl
github "floriankrueger/Manuscript" == 3.0.1
```

If your Swift 3.1 compiler isn't compatible with the framework binary from the github release then 
please use the following command to build Manuscript yourself:
 
```
carthage bootstrap Manuscript --no-use-binaries
```
 
### CocoaPods

Make sure your `Podfile` contains all of the following lines.

```ruby
use_frameworks!
platform :ios, '8.0'

pod 'Manuscript'
```

Then run `pod install`.

### Manually

To do it 'by hand' take the following files and add them to your project:

- `Source/Manuscript.swift`
- `Source/LayoutProxy.swift`

## License

Manuscript is released under the [MIT License](LICENSE.md).
