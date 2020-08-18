# ZBottomSheet

[![CI Status](https://img.shields.io/travis/sxudan/ZBottomSheet.svg?style=flat)](https://travis-ci.org/sxudan/ZBottomSheet)
[![Version](https://img.shields.io/cocoapods/v/ZBottomSheet.svg?style=flat)](https://cocoapods.org/pods/ZBottomSheet)
[![License](https://img.shields.io/cocoapods/l/ZBottomSheet.svg?style=flat)](https://cocoapods.org/pods/ZBottomSheet)
[![Platform](https://img.shields.io/cocoapods/p/ZBottomSheet.svg?style=flat)](https://cocoapods.org/pods/ZBottomSheet)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ZBottomSheet is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZBottomSheet'
```

## Author

sxudan, sudan.suwal@spiralogics.com

## License

ZBottomSheet is available under the MIT license. See the LICENSE file for more info.

## Screenshots
<img src="https://user-images.githubusercontent.com/31989781/90506175-91185100-e173-11ea-931a-e8b4c19f53b1.png" alt="drawing" width="200"/>
<img src="https://user-images.githubusercontent.com/31989781/90506183-94134180-e173-11ea-8670-66f648087598.png" alt="drawing" width="200"/>

## Usage

`let childVC = ...`

`let bottomSheet = ZBottomSheet(parent: self, childController: childVC)`

`bottomSheet.options = SheetOptions(headerTitle: "", contentHeight: .adjustWithTableviewContent, handleBarColor: .systemBlue, panelColor: .white, separatorColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))`

`bottomSheet.showSheet()`
