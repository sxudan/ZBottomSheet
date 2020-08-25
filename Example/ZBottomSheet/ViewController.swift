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
    
    var bottomSheet: ZBottomSheet!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onShow1(_ sender: Any) {
        bottomSheet = ZBottomSheet.View(parent: self)
        let mainView = makeParentView()
        bottomSheet.addBottomSheetView(view: mainView, presentedView: {v in
            v.layer.shadowColor = UIColor.lightGray.cgColor
            v.layer.shadowOffset = CGSize(width: 0, height: 0)
            v.layer.shadowRadius = 2
            v.layer.shadowOpacity = 1

        })
        bottomSheet.addNavigationBar() { navigationBar in
            self.makeNavigationBarWithSearchBarView(navigationBar: navigationBar)
            navigationBar.isTranslucent = true
            return 58 // return height of navigation bar
        }

        bottomSheet.addTableView({(tableView, scrollView) in
            tableView.register(UINib(nibName: "CustomCell1", bundle: nil), forCellReuseIdentifier: "CustomCell1")
            tableView.delegate = self
            tableView.dataSource = self
        })
        bottomSheet.isExpandableToFullHeight = true
        bottomSheet.initialHeight = .adjustWithContent
        bottomSheet.isClosable = false
        bottomSheet.delegate = self
        bottomSheet.enableClipToBar = true
        bottomSheet.showSheet()
//        bottomSheet.state = .BarOnlyPresented
    }
    
    @objc func onPresent() {
        bottomSheet.state = .FullPresented
    }

    @IBAction func onShow2(_ sender: Any) {
        bottomSheet = ZBottomSheet.Controller(parent: self)
        let placement = makeParentView()
    
        
        bottomSheet.addBottomSheetView(view: placement, presentedView: {v in
            v.layer.shadowColor = UIColor.lightGray.cgColor
            v.layer.shadowOffset = CGSize(width: 0, height: 0)
            v.layer.shadowRadius = 2
            v.layer.shadowOpacity = 1
            
            v.addSubview(self.makeHandleView())
        })
        bottomSheet.addNavigationBar() { navigationBar in
            
            let rightItem = UIBarButtonItem(title: "Present", style: .done, target: self, action: #selector(self.onPresent))
//            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.isTranslucent = false
            navigationBar.setItems([UINavigationItem(title: "Simple View")], animated: true)
            navigationBar.topItem?.rightBarButtonItem = rightItem
//            navigationBar.setValue(true, forKey: "hidesShadow")
//            navigationBar.barTintColor = .clear

            return 60
        }

        bottomSheet.addContentView({content in
            content.backgroundColor =  .white
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 45))
            button.translatesAutoresizingMaskIntoConstraints = true
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.setTitle("Dismiss", for: .normal)
            button.center = CGPoint(x: self.view.bounds.width / 2.0, y: 100)
            content.addSubview(button)
            button.addTarget(self, action: #selector(self.onDismissed), for: .touchUpInside)
        })
        bottomSheet.isExpandableToFullHeight = true
        bottomSheet.initialHeight = 300
        bottomSheet.isClosable = true
        bottomSheet.delegate = self
        bottomSheet.enableClipToBar = false
        bottomSheet.showSheet()
    }
       
    
    @IBAction func onShow3(_ sender: Any) {
        bottomSheet = ZBottomSheet.Controller(parent: self)
        let mainView = makeParentView()
        bottomSheet.addBottomSheetView(view: mainView, presentedView: {v in
            v.layer.shadowColor = UIColor.lightGray.cgColor
            v.layer.shadowOffset = CGSize(width: 0, height: 0)
            v.layer.shadowRadius = 2
            v.layer.shadowOpacity = 1
            
        })
        bottomSheet.addNavigationBar() { navigationBar in
            navigationBar.setItems([UINavigationItem(title: "Collection View")], animated: true)
            //            navigationBar.setValue(true, forKey: "hidesShadow")
            navigationBar.barTintColor = .white
            return 45
        }
        
        bottomSheet.addCollectionView({collectionView, scrollView in
            collectionView.register(UINib(nibName: "collectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionviewcell")
            collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            collectionView.backgroundColor = .white
            collectionView.delegate = self
            collectionView.dataSource = self
        })
        bottomSheet.isExpandableToFullHeight = true
        bottomSheet.initialHeight = 300
        bottomSheet.isClosable = true
        bottomSheet.delegate = self
        bottomSheet.enableClipToBar = false
        bottomSheet.showSheet()
    }
    
    
    @objc func onDismissed() {
        bottomSheet.state = .Hidden
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 80
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionviewcell", for: indexPath) as! CollectionViewCell
        cell.indexNo = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let width = ((collectionView.frame.size.width - (padding * 2)) / 3.0) - 16
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        bottomSheet.state = .FullPresented
    }
}

extension ViewController: BottomSheetDelegate {
    func _bottomSheet(presentedView: UIView, stateDidChange state: State) {
        print(state)
        if state == .FullPresented {
            presentedView.layer.shadowOpacity = 0
        } else {
            presentedView.layer.shadowOpacity = 1.0
        }
    }
    
    
    
}


extension ViewController {
    func makeHandleView() -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 6))
        v.layer.cornerRadius = v.frame.height / 2.0
        v.backgroundColor = .lightGray
        v.center = CGPoint(x: self.view.frame.width / 2.0 , y: 6)
        return v
    }
    
    func makeParentView() -> UIView {
        let ui = UIView(frame: .infinite)
        ui.backgroundColor = .white
        ui.layer.cornerRadius = 10
        ui.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        ui.layer.masksToBounds = true
        return ui
    }
    
    func makeNavigationBarWithSearchBarView(navigationBar: UINavigationBar) {
        navigationBar.isTranslucent = true
        
        navigationBar.barTintColor = UIColor.white.withAlphaComponent(0.6)
        
        //            navigationBar.setValue(true, forKey: "hidesShadow")
        
        let searchBar = UISearchBar(frame: .infinite)
        
        
        searchBar.backgroundColor = .white
        
        searchBar.delegate = self
        
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
            textField.textColor = .darkGray
            
            textField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            
            if let glassIconView = textField.leftView as? UIImageView {
                
                //Magnifying glass
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = .darkGray
            }
            
            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) { // If `searchController` is in `navigationItem`
                backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3) //Or any transparent color that matches with the `navigationBar color`
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() }) // Fixes an UI bug when searchBar appears or hides when scrolling
            }
            backgroundView?.layer.cornerRadius = 10.5
            backgroundView?.layer.masksToBounds = true
            //Continue changing more properties...
        }
        searchBar.placeholder = "Search"
        let navigationItem = UINavigationItem()
        
        navigationItem.titleView = searchBar
        
        navigationBar.setItems([navigationItem], animated: true)
    }
}
