//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by sudansuwal on 8/17/20.
//  Copyright © 2020 Spiralogics. All rights reserved.
//

import UIKit

extension CGFloat {
    public static let fullscreen: CGFloat = -2
    public static let halfscreen: CGFloat = -1
    public static let adjustWithTableviewContent: CGFloat = -3
}

public struct SheetOptions {
    var headerTitle: String?
    var contentViewHeight: CGFloat
    var handleBarColor: UIColor
    var panelColor: UIColor
    var separatorColor: UIColor
    
    public init() {
        self.headerTitle = ""
        self.contentViewHeight = 0
        self.handleBarColor = .systemBlue
        self.separatorColor = .clear
        self.panelColor = .white
    }
    
    public init(headerTitle: String = "", contentHeight: CGFloat = 200, isExpandableToFull: Bool = false, handleBarColor: UIColor = .systemBlue, panelColor: UIColor = .white, separatorColor: UIColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)) {
        self.headerTitle = headerTitle
        self.contentViewHeight = contentHeight
        self.handleBarColor = handleBarColor
        self.panelColor = panelColor
        self.separatorColor = separatorColor
    }
}

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var handleBar: UIViewExt!
    @IBOutlet weak var topPaneHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topPane: UIView!
    @IBOutlet weak var parentView: UIView!
    var childController: UIViewController!
    @IBOutlet weak var bottomSheetHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var draggableView: UIView!
    var delegate: BottomSheetDelegate?
    @IBOutlet weak var mainParent: UIView!
    
    var dragGesture: UIPanGestureRecognizer!
    var tapGesture: UITapGestureRecognizer!
    
    var options: SheetOptions?
    @IBOutlet weak var headerTitle: UILabel!
    ///
    var minimumHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMinHeight()
        addChildController()
        setupTopPane()
        addGesture()
        setupUI()
    }
    
    func initMinHeight() {
        ///default
        minimumHeight = 200 + topPaneHeightConstraint.constant
    }
    
    func setupUI() {
        if let opt = options {
            print(opt)
            self.headerTitle.text = opt.headerTitle
            var height: CGFloat = 0
            handleBar.backgroundColor = opt.handleBarColor
            topPane.backgroundColor = opt.panelColor
            separator.backgroundColor = opt.separatorColor
            
            if opt.contentViewHeight == .fullscreen {
                height = getFullscreenSheetHeight() - topPaneHeightConstraint.constant - UIApplication.shared.statusBarFrame.size.height
            } else if opt.contentViewHeight == .halfscreen {
                height = (UIScreen.main.bounds.height / 2.0) - topPaneHeightConstraint.constant  - UIApplication.shared.statusBarFrame.size.height
            } else {
                height = CGFloat(opt.contentViewHeight)
            }
            self.minimumHeight = height + topPaneHeightConstraint.constant
        }
    }
    
    @objc func onBackgroundTapped() {
        self.close()
    }
    
    func setOption(option: SheetOptions) {
        self.options = option
        setupUI()
        self.view.layoutIfNeeded()
    }
    
    func getFullscreenSheetHeight() -> CGFloat {
        let height = UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.size.height
        return height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bottomSheetHeightConstraint.constant = minimumHeight
        self.bottomSheetHeightConstraint.constant = 0
        self.view.layoutIfNeeded()
        if options?.contentViewHeight == CGFloat.adjustWithTableviewContent {
            manageTableView(view: self.parentView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            UIView.animate(withDuration: 0.3, animations: {
                self.delegate?._bottomSheetPresented()
                self.bottomSheetHeightConstraint.constant = self.minimumHeight
                self.view.layoutIfNeeded()
            })
        })
    }
    
    func addGesture() {
        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(gesture:)))
        draggableView.addGestureRecognizer(dragGesture)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped))
        background.addGestureRecognizer(tapGesture)
    }
    
    func getTableView(v:UIView) -> UITableView? {
        for subview in v.allSubviews {
            if subview is UITableView {
                return subview as? UITableView
            }
        }
        return nil
    }
    
    func close() {
        self.dismiss(animated: false, completion: {
            self.delegate?._bottomSheetDismissed()
        })
    }
    
    @available(iOS 12.0, *)
    func addChildController() {
        addChild(childController)
        childController.view.frame = self.parentView.bounds
        self.parentView.addSubview(childController.view)
        childController.didMove(toParent: self)
    }
    
    func manageTableView(view: UIView) {
        
        if let tableview = getTableView(v: view) {
            let cells = tableview.visibleCells
            var height: CGFloat = 0
            
            if cells.count > 0 {
                let h = cells[0].frame.height
                let sections: Int = tableview.numberOfSections
                var rows: Int = 0
                
                for i in 0..<sections {
                    rows += tableview.numberOfRows(inSection: i)
                }
                height = (CGFloat(rows) * h) + 16.0
            }
            if height > getFullscreenSheetHeight() {
                height = getFullscreenSheetHeight() - topPaneHeightConstraint.constant - UIApplication.shared.statusBarFrame.size.height
            }
            options?.contentViewHeight = height
            self.setupUI()
        } else {
//            print("table view not found")
        }
    }
    
    func setupTopPane() {
        self.mainParent.layer.cornerRadius = 30
        if #available(iOS 11.0, *) {
            self.mainParent.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func onPan(gesture: UIPanGestureRecognizer) {
        let v = gesture.view
        let t = gesture.translation(in: v)
        let offsetY = t.y
        let trans = self.minimumHeight - offsetY
        if gesture.state == UIGestureRecognizer.State.began || gesture.state == UIGestureRecognizer.State.changed {
            if trans > self.minimumHeight {
                if trans > (self.minimumHeight + 150) {
                }
            } else {
                self.bottomSheetHeightConstraint.constant = trans
                self.view.updateConstraintsIfNeeded()
                gesture.setTranslation(CGPoint(x: t.x, y: offsetY), in: v)
            }
            
        } else {
            if trans <= (self.minimumHeight - (self.minimumHeight / 2.0)) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.bottomSheetHeightConstraint.constant = 50
                    self.close()
                })
                
            } else if trans > (self.minimumHeight - (self.minimumHeight / 2.0)) && trans < self.minimumHeight {
                self.bottomSheetHeightConstraint.constant = self.minimumHeight
                self.view.updateConstraintsIfNeeded()
                gesture.setTranslation(CGPoint(x: t.x, y: self.minimumHeight), in: v)
            }
            
            
        }
    }
}

fileprivate extension UIView {
    var allSubviews: [UIView] {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
}
