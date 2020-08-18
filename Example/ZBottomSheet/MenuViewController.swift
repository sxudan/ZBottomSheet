//
//  MenuViewController.swift
//  BottomSheet_Example
//
//  Created by sudansuwal on 8/18/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuListView.tableFooterView = UIView()
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "cell\(indexPath.row + 1)"
        print(cellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    
}
