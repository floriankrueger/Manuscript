![Manuscript: Dead-Simple AutoLayout](https://raw.githubusercontent.com/floriankrueger/Manuscript/assets/manuscript.png)

It's like [AutoLayoutKit](https://github.com/floriankrueger/AutoLayoutKit) but written in Swift. For pure Swift projects. And it's super simple.

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

### Center a UIView 'childView' in self.view and make it 30 by 30 in size

```swift
Manuscript.layout(childView) { c in
  c.make(.CenterX, equalTo: self.view, s: .CenterX)
  c.make(.CenterY, equalTo: self.view, s: .CenterY)
  c.set(.Width, to: 30.0)
  c.set(.Height, to: 30.0)
}
```

### The same, but using the convenience methods

```swift
Manuscript.layout(childView) { c in
  c.centerIn(self.view)
  c.setSize(CGSize(width: 30.0, height: 30.0))
}
```
