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
![alt text](https://paste.pics/4346f05064dee37141c4b297108323e8)
![alt text](https://paste.pics/c4996733b9f6989d9d6324a023f4d945)

## Usage

`let childVC = ...`

`let bottomSheet = ZBottomSheet(parent: self, childController: childVC)`

`bottomSheet.options = SheetOptions(headerTitle: "", contentHeight: .adjustWithTableviewContent, handleBarColor: .systemBlue, panelColor: .white, separatorColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))`

`bottomSheet.showSheet()`
