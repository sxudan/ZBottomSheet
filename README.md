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

## Demo
</br>
<b> Type: Controller </b>
</br>
<img src="https://user-images.githubusercontent.com/31989781/91003183-62293180-e5f0-11ea-8e4c-7379e0db3223.gif" width="320" > 
</br>
<img src="https://user-images.githubusercontent.com/31989781/91004110-fdbba180-e5f2-11ea-8b3a-5b1ad3478952.gif" width="320" > 
</br></br>
<b> Type: View </b>
</br>
<img src="https://user-images.githubusercontent.com/31989781/91003842-2d1dde80-e5f2-11ea-9822-5f1fdc2bff50.gif" width="320" > 
</br></br>


## Usage

<b>Controller</b> </br>
```let controller = ZBottomSheet.Controller(parent: self) ```
</br>
```controller.showSheet() ```
</br></br>
<b>View</b> </br>
```let sheetView = ZBottomSheet.View(parent: self) ```
</br>
```sheetView.showSheet() ```

</br></br>
<b>Properties</b>
</br>
`var isClosable: Bool { get set }`
</br>
`var enableClipToBar: Bool { get set }`
</br>
`var initialHeight: CGFloat { get set }`
</br>
`var isExpandableToFullHeight: Bool! { get set }`
</br>
`func addNavigationBar(_ navigationBarHandler: @escaping (UINavigationBar) -> CGFloat)`
</br>
`func addTableView(_ tableViewHandler: @escaping (UITableView, UIScrollView) -> Void)`
</br>
`func addCollectionView(flowLayout: UICollectionViewFlowLayout?,_ collectionViewHandler: @escaping (UICollectionView, UIScrollView) -> Void)`
</br>
`func addBottomSheetView(view: UIView, presentedView viewHandler: @escaping (UIView) -> Void)`
</br>
`func addScrollView(_ scrollViewHandler: @escaping (UIScrollView) -> Void)`
</br>
`func addContentView(_ contentViewHandler: @escaping (UIView) -> Void)`
</br>
`var state: State! { get set }`
</br>

</br></br></br>
<a href="" >Please refer to the examples and feel free to email me.....</a>
