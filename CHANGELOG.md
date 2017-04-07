# Changelog

## Version 3.0.3

- [x] Podspec fixed (I missed the last release in Cocoapods)
- [x] Constraints on a view that relate to the view itself were previously created on the superview.
This is now fixed, the constraints are created on the view itself which makes the 

## Version 3.0.2

- [x] Swift 3.1 / Xcode 8.3 compatibility

## Version 3.0.1

- [x] Swift 3.0.1 / Xcode 8.1 compatibility

## Version 3.0.0

- [x] Swift 3 compatibility

## Version 2.0.0

- [x] New Repository structure
- [x] Swift 3 compatibility (as far as we know for now)
- [x] Custom identifiers for Constraints for easier debugging

## Version 0.0.6

- [x] Documentation for Base API
- [x] Documentation for Convenience API

## Version 0.0.5

- [x] Cocoapods compatibility

## Version 0.0.4

- [x] Automatically tested via Circle CI (still no Swift 1.2 support on Travis C.I.)

## Version 0.0.3

- [x] Changed public APIs from `Float` to `CGFloat`

## Version 0.0.2

- [x] Readme
- [x] Changelog

## Version 0.0.1

- [x] Initial Release
- [x] Base API (make/set incl. Equal, Greater Than, Less Than)
- [x] Convenience API (alignAllEdgesTo, CenterIn, Hairline)
- [x] Unit tests
