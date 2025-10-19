# SwiftSignatureView (now with PencilKit!)

[![Version](https://img.shields.io/cocoapods/v/SwiftSignatureView.svg?style=flat)](http://cocoapods.org/pods/SwiftSignatureView)
[![License](https://img.shields.io/cocoapods/l/SwiftSignatureView.svg?style=flat)](http://cocoapods.org/pods/SwiftSignatureView)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSignatureView.svg?style=flat)](http://cocoapods.org/pods/SwiftSignatureView)

## Description
SwiftSignatureView is a lightweight, fast and customizable option for capturing signatures within your app. You can retrieve the signature as a UIImage. With code that varies the pen width based on the speed of the finger movement, the view generates fluid, natural looking signatures. *And now, with iOS13+, SwiftSignatureView automatically uses PencilKit to provide a native and even more fluid signature experience, including a natural integration with the Apple Pencil which makes SwiftSignatureView even better!*

<img width="432" height="243" alt="swiftsignatureview" src="https://github.com/user-attachments/assets/c3601521-8d80-419a-9e7e-5d961f3d0425" />

## Version 3.2.3
- Updated the Swift Package version to 5.9
- Updated the platform minimums to v12 since older is now deprecated
- Added VisionOS support
  

<img width="800" height="570" alt="visionos" src="https://github.com/user-attachments/assets/bc37fe03-1d07-479d-bce6-9dd88c76db38" />


## Version 3.2.1
- Minor bug fixes. 

## Version 3.2.0 
- _WARNING_: This update changes the _SwiftSignatureViewDelegate_ interface. Use the _swiftSignatureViewDidDrawGesture_ to receive gesture events. In PencilKit (iOS13+) you get an additional _swiftSignatureViewDidDraw_ event when the user ends a drawing sequence with the tool they were using.
- Added Undo/Redo.
- Added _isEmpty_ to determine if the signature canvas is empty.
- Fixed the constraints of the demo app. 
- Views and canvas are configured internally only using constraint layout.
- Swiftlint fixes applied.
- Added a page sheet version explaining how to use the library purely by code.
- Added crop function for the PencilKit version (with resolution of the signature sorted).

## Version 3.0.0 
- SwiftSignatureView now uses PencilKit for iOS13+ to provide a native and even more fluid signature experience, including a natural integration with the Apple Pencil. 

### Known issues
- Currently the *getCroppedSignature* method won't work as expected with iOS13+ and instead returns the uncropped image. 

## Version 2.2.3 | Swift 5.0
- SwiftSignatureView now draws from the point of touch instead of the point from where the pan gesture was recognized.


## Version 2.2.2 | Swift 5.0
- Modified the *swiftSignatureViewDidPanInside* delegate method to include the pan gesture recognizer in the callback. 
  _Warning_: This will change the interface!

## Version 2.2.0 | Swift 5.0 
- Added a *getCroppedSignature* method to get a UIImage of the signature with surrounding whitespace trimmed
- Made the signature image publicly settable
- Modified the example to demonstrate the cropped signature function

[ A big thank you to all the contributors. I know I don't say it enough. ]

## Version 2.1.0 | Swift 5.0 
- Updated the Pod to Swift 5.0 syntax. The interface remains unchanged.

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

you can use

```swift
signatureView.signature()
```

to get a UIImage representation of the signature;

```swift
signatureView.getCroppedSignature()
```

to get a UIImage representation of the cropped signature with the surrounding whitespace trimmed.

```swift
signatureView.clear()
```

to clear the signature view.

## Installation

SwiftSignatureView is available through [CocoaPods](http://cocoapods.org) and Swift Package Manager.

### For Cocoapods >= 1.0 

Add the following lines to your Podfile:

```ruby
use_frameworks!
target "YOUR_PROJECT_NAME" do
    pod "SwiftSignatureView"
end
```

### For Cocoapods < 1.0

Add the following lines to your Podfile:

```ruby
use_frameworks!
pod "SwiftSignatureView"
```

### For Swift Package Manager

Add the following lines to your Package.swift file (or just use the Package Manager from within XCode and reference this repo):

```swift
dependencies: [
    .package(url: "https://github.com/alankarmisra/SwiftSignatureView.git", from: "3.2.3")
]
```

## Questions? Write in to:

Alankar Misra, alankarmisra@gmail.com

## License

SwiftSignatureView is available under the MIT license. See the LICENSE file for more info.
