![Manuscript: Dead-Simple AutoLayout](https://raw.githubusercontent.com/floriankrueger/Manuscript/assets/manuscript.png)

It's like [AutoLayoutKit](https://github.com/floriankrueger/AutoLayoutKit) but written in Swift. For pure Swift projects. And it's super simple.

## Features

- [x] concise, simple and convenient API
- [x] raw AutoLayout power
- [x] no black magic involved
- [] fully documented
- [x] completely unit-tested

Have a look at the [Changelog](CHANGELOG.md) for more details.

## Requirements

- iOS 8.0+
- Xcode 6.3

## What it looks like

```swift
Manuscript.layout(myButton) { c in
  c.set(.Height, to:60.0)
  c.set(.Width, to:60.0)
  c.make(.Bottom, equalTo:self.view, s:.Bottom, minus: 10.0)
  c.make(.CenterX, equalTo:self.view, s:.CenterX)
}
```
