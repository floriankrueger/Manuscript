![Manuscript: Dead-Simple AutoLayout](https://raw.githubusercontent.com/floriankrueger/Manuscript/assets/manuscript.png)

It's like [AutoLayoutKit](https://github.com/floriankrueger/AutoLayoutKit) but written in Swift.
For pure Swift projects. And it's super simple.

## Features

- [x] concise, simple and convenient API
- [x] raw AutoLayout power
- [x] no black magic involved
- [ ] fully documented
- [x] completely unit-tested

Have a look at the [Changelog](CHANGELOG.md) for more details.

## Requirements

- iOS 8.0+
- Xcode 6.3

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
  c.make(.CenterX, equalTo: self.view, s: .CenterX)
  c.make(.CenterY, equalTo: self.view, s: .CenterY)
  c.set(.Width, to: 30.0)
  c.set(.Height, to: 30.0)
}
```

The same, but using the convenience methods

```swift
Manuscript.layout(childView) { c in
  c.centerIn(self.view)
  c.setSize(CGSize(width: 30.0, height: 30.0))
}
```

### Align all edges of a view to a superview

Align a UIView 'container' to all edges of self.view

```swift
Manuscript.layout(container) { c in
  c.make(.Left, equalTo: self.view, s: .Left)
  c.make(.Right, equalTo: self.view, s: .Right)
  c.make(.Top, equalTo: self.view, s: .Top)
  c.make(.Bottom, equalTo: self.view, s: .Bottom)
}
```

The same, but using the convenience methods

```swift
Manuscript.layout(container) { c in
  c.alignAllEdges(to: self.view)
}
```

### Align all sides with insets

Align a UIView 'container' to all edges of self.view and leave a 30 point margin around the
container.

```swift
Manuscript.layout(container) { c in
  c.make(.Left, equalTo: self.view, s: .Left, plus: 30.0)
  c.make(.Right, equalTo: self.view, s: .Right, minus: 30.0)
  c.make(.Top, equalTo: self.view, s: .Top, plus: 30.0)
  c.make(.Bottom, equalTo: self.view, s: .Bottom, minus: 30.0)
}
```

The same, but using convenience methods.

```swift
Manuscript.layout(container) { c in
  c.alignAllEdges(to: self.view, withInsets: UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 30.0))
}
```

### Use LayoutGuides

Make use of the LayoutGuides provided by UIViewController.

```swift
Manuscript.layout(container) { c in
  c.make(.Left, equalTo: self.view, s: .Left)
  c.make(.Right, equalTo: self.view, s: .Right)
  c.make(.Top, equalTo: self.topLayoutGuide, s: .Baseline)
  c.make(.Bottom, equalTo: self.bottomLayoutGuide, s: .Baseline)
}
```

### Work with the created Layout Constraints

The functions `make` and `set` return a tuple of type `LayoutItem` which translates to
`(constraint: NSLayoutConstraint?, targetItem: UIView?)`. The 'constraint' is the created
`NSLayoutConstraint`, the 'targetItem' is the view to which the `NSLayoutConstraint` was added. It
is the nearest common superview of the `UIView`s involved.

```swift
Manuscript.layout(container) { c in
  self.leftConstaint = c.make(.Left, equalTo: self.view, s: .Left).constraint
  self.rightConstaint = c.make(.Right, equalTo: self.view, s: .Right).constraint
  self.topConstaint = c.make(.Top, equalTo: self.topLayoutGuide, s: .Baseline).constraint
  self.bottomConstaint = c.make(.Bottom, equalTo: self.bottomLayoutGuide, s: .Baseline).constraint
}
```

Afterwards, just modify the constraint's constant and apply the changes (this is plain AutoLayout).

```swift
UIView.animateWithDuration(0.6) { in
  self.topConstraint?.constant = 100
  self.view.layoutIfNeeded()
}
```

The convenience methods return arrays of the mentioned tuples. These will be dictionaries or tuples
in the future as well to provide easier access to the created constraints. Until then, check the
code for the order of the returned constraints.

## Installation

As for now, you can use [Carthage](https://github.com/Carthage/Carthage) to install Manuscript
using a dependency manager or do it manually.

### Carthage

To integrate Manuscript into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "floriankrueger/Manuscript"
```

### Manually

To do it 'by hand' take the following files and add them to your project:

- `Source/Manuscript.swift`
- `Source/LayoutProxy.swift`
