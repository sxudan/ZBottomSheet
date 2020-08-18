//
//  UIVIewExt.swift
//  BottomSheet
//
//  Created by sudansuwal on 8/17/20.
//  Copyright © 2020 Spiralogics. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UIViewExt: UIView {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = true
        }
    }
}
