//
//  CollectionViewCell.swift
//  ZBottomSheet_Example
//
//  Created by sudansuwal on 8/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let images = ["dog1"]
    
    var indexNo: Int! {
        didSet {
//            let i = (self.indexNo % 4) + 1
            let i = arc4random_uniform(4) + 1;
            let name = "dog\(i)"
            self.imageView.image = UIImage(named: name)
        }
    }
}
