//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by sudansuwal on 8/17/20.
//  Copyright © 2020 Spiralogics. All rights reserved.
//

import Foundation
import UIKit

public protocol BottomSheetDelegate {
    func _bottomSheet(presentedView: UIView, stateDidChange state: State)
}

extension CGFloat {
    public static let fullscreen: CGFloat = -2
    public static let halfscreen: CGFloat = -1
    public static let adjustWithContent: CGFloat = -3
}

public enum State {
    case FullPresented
    case HalfPresented
    case BarOnlyPresented
    case Hidden
}

public protocol BottomSheetModel {
    var isClosable: Bool { get set }
    var enableClipToBar: Bool { get set }
    var initialHeight: CGFloat { get set }
    var isExpandableToFullHeight: Bool! { get set }
    func addNavigationBar(_ navigationBarHandler: @escaping (UINavigationBar) -> CGFloat)
    func addTableView(_ tableViewHandler: @escaping (UITableView, UIScrollView) -> Void)
    func addCollectionView(flowLayout: UICollectionViewFlowLayout?,_ collectionViewHandler: @escaping (UICollectionView, UIScrollView) -> Void)
    func addBottomSheetView(view: UIView, presentedView viewHandler: @escaping (UIView) -> Void)
    func addScrollView(_ scrollViewHandler: @escaping (UIScrollView) -> Void)
    func addContentView(_ contentViewHandler: @escaping (UIView) -> Void)
    var state: State! { get set }
}


enum SheetType {
    case View
    case Controller
}

public class ZBottomSheet: NSObject, BottomSheetModel {

    public var isClosable: Bool = true
    public var enableClipToBar: Bool = false
    public var state: State! {
        didSet {
            if ZBottomSheet.type == .View {
                ZBottomSheet.sheetView.state = self.state
            } else {
                ZBottomSheet.sheetChildViewController.sheetView.state = self.state
            }
        }
    }
    public var isExpandableToFullHeight: Bool! = false
    public var initialHeight: CGFloat = 45
    
    private static var parent: UIViewController!
    
//    var bottomSheetController: BottomSheetViewController!
    public var delegate: BottomSheetDelegate?
    
//    public var options: SheetOptions?
    
    typealias NavigationHandler = (UINavigationBar) -> CGFloat
    typealias TableViewHandler = (UITableView, UIScrollView) -> Void
    typealias PresentViewHandler = (UIView) -> Void
    typealias ScrollViewHandler = (UIScrollView) -> Void
    typealias ContentViewHandler = (UIView) -> Void
    typealias CollectionViewHandler = (UICollectionView, UIScrollView) -> Void
    
    var navigationHandler: NavigationHandler?
    var tableViewHandler: TableViewHandler?
    var presentedViewHandler: PresentViewHandler?
    var scrollViewHandler: ScrollViewHandler?
    var contentViewHandler: ContentViewHandler?
    var collectionViewHandler: CollectionViewHandler?
    var collectionFlowLayout: UICollectionViewFlowLayout?
    
    var placementView: UIView?
    
    private static var sheet = ZBottomSheet()
    
    private static var sheetView: UISheetView!
    
    private static var sheetChildViewController: ChildViewController!
    
    private static var type: SheetType = .View
    
    private override init() {
        super.init()
    }
    
    func clearHandler() {
        navigationHandler = nil
        tableViewHandler = nil
        presentedViewHandler = nil
        scrollViewHandler = nil
        contentViewHandler = nil
        collectionViewHandler = nil
    }
    
    public class func View(parent: UIViewController) -> ZBottomSheet {
        self.parent = parent
        if sheetView != nil {
            sheetView.destroy()
        }
        sheetView = UISheetView(frame: .infinite)
        ZBottomSheet.type = .View
        ZBottomSheet.sheet.clearHandler()
        return ZBottomSheet.sheet
    }
    
    public class func Controller(parent: UIViewController) -> ZBottomSheet {
        self.parent = parent
        if sheetView != nil {
            sheetView.destroy()
        }
        sheetView = UISheetView(frame: .infinite)
        sheetChildViewController = ChildViewController()
        sheetChildViewController.modalPresentationStyle = .overCurrentContext
        ZBottomSheet.type = .Controller
        ZBottomSheet.sheet.clearHandler()
        return ZBottomSheet.sheet
    }
    
    
    public func showSheet() {
        ZBottomSheet.sheetView.initialHeight = initialHeight
        ZBottomSheet.sheetView.isExpandableToFullHeight = isExpandableToFullHeight
        ZBottomSheet.sheetView.delegate = delegate
        ZBottomSheet.sheetView.isClosable = self.isClosable
        ZBottomSheet.sheetView.enableClipToBar = self.enableClipToBar
        ZBottomSheet.sheetView.type = ZBottomSheet.type
        
        if ZBottomSheet.type  == .View {
            ZBottomSheet.sheetView.presentView(parent: ZBottomSheet.parent)
        } else {
            ZBottomSheet.sheetChildViewController.sheetView = ZBottomSheet.sheetView
            ZBottomSheet.parent.present(ZBottomSheet.sheetChildViewController, animated: false, completion: nil)
            
        }
        
        if let placementView = placementView, let presentedHandler = presentedViewHandler {
            ZBottomSheet.sheetView.addBottomSheetView(view: placementView, presentedView: presentedHandler)
        }
        
        if let navigationHandler = navigationHandler {
            ZBottomSheet.sheetView.addNavigationBar(navigationHandler)
        }
        
        
        if let tableViewHandler = tableViewHandler {
            ZBottomSheet.sheetView.addTableView(tableViewHandler)
        }
        
        if let scrollViewHandler = self.scrollViewHandler {
            ZBottomSheet.sheetView.addScrollView(scrollViewHandler)
        }
        
        if let collectionViewHandler = self.collectionViewHandler {
            ZBottomSheet.sheetView.addCollectionView(flowLayout: self.collectionFlowLayout,collectionViewHandler)
        }
        
        if let contentViewHandler = self.contentViewHandler {
            ZBottomSheet.sheetView.addContentView(contentViewHandler)
        }
       
    }
    
    public func addNavigationBar(_ navigationBarHandler: @escaping (UINavigationBar) -> CGFloat) {
        self.navigationHandler = navigationBarHandler
        
    }
    
    public func addContentView(_ contentViewHandler: @escaping (UIView) -> Void) {
        self.contentViewHandler = contentViewHandler
    }
    
    public func addScrollView(_ scrollViewHandler: @escaping (UIScrollView) -> Void) {
        self.scrollViewHandler = scrollViewHandler
    }
    
    public func addTableView(_ tableViewHandler: @escaping (UITableView, UIScrollView) -> Void) {
        self.tableViewHandler = tableViewHandler
    }
    
    public func addCollectionView(flowLayout: UICollectionViewFlowLayout? = nil, _ collectionViewHandler: @escaping (UICollectionView, UIScrollView) -> Void) {
        self.collectionFlowLayout = flowLayout
        self.collectionViewHandler = collectionViewHandler
    }
    
    public func addBottomSheetView(view: UIView, presentedView viewHandler: @escaping (UIView) -> Void) {
        placementView = view
        presentedViewHandler = viewHandler
    }
   
    
    var frameworkBundle:Bundle? {
        let bundleId = "org.cocoapods.ZBottomSheet"
        return Bundle(identifier: bundleId)
    }
    
}
