# SwiftSignatureView (Swift 3.0 / Xcode 8)

[![CI Status](http://img.shields.io/travis/Alankar Misra/SwiftSignatureView.svg?style=flat)](https://travis-ci.org/Alankar Misra/SwiftSignatureView)
[![Version](https://img.shields.io/cocoapods/v/SwiftSignatureView.svg?style=flat)](http://cocoapods.org/pods/SwiftSignatureView)
[![License](https://img.shields.io/cocoapods/l/SwiftSignatureView.svg?style=flat)](http://cocoapods.org/pods/SwiftSignatureView)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSignatureView.svg?style=flat)](http://cocoapods.org/pods/SwiftSignatureView)

## Description
SwiftSignatureView is a lightweight, fast and customizable option for capturing signatures within your app. You can retrieve the signature as a UIImage. With code that varies the pen width based on the speed of the finger movement, the view generates fluid, natural looking signatures. 

![Sample](http://i.imgur.com/dnXs4ND.png)

## Version 2.0 | Swift 3.0 / XCode 8

- Upgraded the Pod to Swift 3.0 syntax. The interface remains unchanged. 

## Version 1.0.3 | Swift 2.3 / XCode 8 compatibility

- Upgraded the Example to use XCode 8 Storyboards. The SwiftSignatureView class file, however, remains unchanged when 'upgraded' to Swift 2.3.

#### Version 1.0.2 | Callbacks for panning/tapping

- Added delegate for callbacks on panning/tapping.

#### Version 1.0.1 | Bug fixes and Syntax updates to Swift 2.2

- Fixes an issue where the signature might appear blurred on retina displays
- Updates the syntax to Swift 2.2
- Fixes pod spec to make it compatible with Cocoapods 1.0

#### Version 0.0.8 | Bug fixes

Version 0.0.8 fixes a bug that caused SwiftSignatureView to compute incorrect offsets when not in full-screen mode. A big thank you to [Todd Kersey](https://github.com/tokersey) for discovering the bug and suggesting a fix. This update fixes the issue.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first. 

More specifically, you simply assign the *SwiftSignatureView* class to a UIView, optionally play with the minimum stroke width, maximum stroke width, stroke color and stroke alpha all which are settable from within the Interface Builder itself and you're all set! You can then use the *signature* property to get a UIImage representation of the signature and the *clear* method to clear the signature view. For example if you had:

```swift
@IBOutlet weak var signatureView: SwiftSignatureView!
```

you could use

```swift
signatureView.signature
```

to get a UIImage representation of the signature and 

```swift
signatureView.clear()
```

to clear the signature view.

## Installation

SwiftSignatureView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

### For Cocoapods >= 1.0 

```ruby
use_frameworks!
target "YOUR_PROJECT_NAME" do
    pod "SwiftSignatureView"
end
```

### For Cocoapods < 1.0

```ruby
use_frameworks!
pod "SwiftSignatureView"
```

## Author

Alankar Misra, alankarmisra@gmail.com

## License

SwiftSignatureView is available under the MIT license. See the LICENSE file for more info.
