//
//  ViewController.swift
//  BottomSheet
//
//  Created by sxudan on 08/18/2020.
//  Copyright (c) 2020 sxudan. All rights reserved.
//

import UIKit
import ZBottomSheet

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func onShow1(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let bottomSheet = ZBottomSheet(parent: self, childController: vc)
        bottomSheet.options = SheetOptions(headerTitle: "", contentHeight: .adjustWithTableviewContent, handleBarColor: .systemBlue, panelColor: .white, separatorColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
        bottomSheet.showSheet()
    }
    
    @IBAction func onShow2(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let bottomSheet = ZBottomSheet(parent: self, childController: vc)
        bottomSheet.options = SheetOptions(headerTitle: "", contentHeight: .halfscreen, handleBarColor: .red, panelColor: .white, separatorColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
        bottomSheet.showSheet()
    }
    
    @IBAction func onShow3(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let bottomSheet = ZBottomSheet(parent: self, childController: vc)
        bottomSheet.options = SheetOptions(headerTitle: "", contentHeight: .fullscreen, handleBarColor: .red, panelColor: .white, separatorColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
        bottomSheet.showSheet()
    }
}

