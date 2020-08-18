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
    func _bottomSheetDismissed()
    func _bottomSheetPresented()
}

public class ZBottomSheet: NSObject {
    
    var parent: UIViewController!
    var bottomSheetController: BottomSheetViewController!
    public var delegate: BottomSheetDelegate?
    
    public var options: SheetOptions?
    
    public init (parent: UIViewController, childController: UIViewController) {
        super.init()
        
        self.parent = parent
        bottomSheetController = BottomSheetViewController(nibName: "BottomSheetViewController", bundle: frameworkBundle)
        bottomSheetController.childController = childController
        bottomSheetController.modalPresentationStyle = .overCurrentContext
    }
    
    public func showSheet() {
        bottomSheetController.options = self.options
        bottomSheetController.delegate = delegate
        parent.present(bottomSheetController, animated: false, completion: nil)
    }
    
    var frameworkBundle:Bundle? {
        let bundleId = "org.cocoapods.ZBottomSheet"
        return Bundle(identifier: bundleId)
    }
    
    func setOptions(option: SheetOptions) {
        bottomSheetController.setOption(option: option)
    }
    
}
