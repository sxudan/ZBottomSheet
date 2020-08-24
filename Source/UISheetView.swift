//
//  UISheetView.swift
//  Pods-ZBottomSheet_Example
//
//  Created by sudansuwal on 8/21/20.
//

import UIKit

public class UISheetView: UIView, BottomSheetModel {
    
    
    //MARK: Properties
    public var enableClipToBar: Bool = false
    public var isClosable: Bool = true
    var type: SheetType = .Controller
    var navigationBarOffset: CGFloat = 12
    public var isExpandableToFullHeight: Bool! = false
    var placementView: UIView!
    public var initialHeight: CGFloat = 45
    private var navigationBar: UINavigationBar?
    private var tableView: UITableView?
    private var scrollView: UIScrollView?
    private var collectionView: UICollectionView?
    var contentView: UIView?
    private var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    private var maxHeight: CGFloat {
        return parentViewController.view.frame.height - statusBarHeight
    }
    fileprivate lazy var getNavigationBarHeight: CGFloat = {
        return UINavigationBar().intrinsicContentSize.height
    }()
    var navigationBarHeight: CGFloat!
    var tapGesture: UITapGestureRecognizer!
    var dragGesture: UIPanGestureRecognizer!
    var delegate: BottomSheetDelegate?
    var tableViewHeightConstraint: NSLayoutConstraint?
    var collectionViewHeightConstraint: NSLayoutConstraint?
    var bottomSheetHeightConstraint: NSLayoutConstraint!
    private var parentViewController: UIViewController!
    
    //MARK: STATE OF BOTTOM SHEET
    public var state: State! = .Hidden {
        didSet {
            scrollView?.isScrollEnabled = false
            let minimumHeight = CGFloat(initialHeight)
            switch self.state {
            case .BarOnlyPresented:
                self.bottomSheetHeightConstraint.constant = navigationBarHeight + navigationBarOffset
                self.layoutIfNeeded()
            case .FullPresented:
                scrollView?.isScrollEnabled = true
                self.bottomSheetHeightConstraint.constant = maxHeight
                self.layoutIfNeeded()
            case .HalfPresented:
                if minimumHeight < 0 {
                    self.bottomSheetHeightConstraint.constant = navigationBarHeight + navigationBarOffset
                } else {
                    self.bottomSheetHeightConstraint.constant = minimumHeight
                }
                self.layoutIfNeeded()
            case .Hidden:
                self.bottomSheetHeightConstraint.constant = 45
                UIView.animate(withDuration: 0.3, animations: {
                    self.layoutIfNeeded()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.close()
                })
            case .none:
                break
            }
            self.delegate?._bottomSheet(presentedView: self, stateDidChange: self.state)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        initialize()
        addGesture()
    }
    
    
    func initialize() {
        self.initialHeight = 45
        navigationBarHeight = getNavigationBarHeight
    }
    
    func destroy() {
        clearAll()
        self.removeFromSuperview()
    }
    
    public func addNavigationBar(_ navigationBarHandler: (UINavigationBar) -> CGFloat) {
        let bar = UINavigationBar()
        self.placementView.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: bar,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: placementView,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: navigationBarOffset)
        
        let leadingConstraint = NSLayoutConstraint(item: bar,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: placementView,
                                                   attribute: .leading,
                                                   multiplier: 1.0,
                                                   constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: bar,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: placementView,
                                                    attribute: .trailing,
                                                    multiplier: 1.0,
                                                    constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: bar,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .height,
                                                  multiplier: 1,
                                                  constant: navigationBarHeight)
        
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, heightConstraint])
        self.navigationBarHeight = navigationBarHandler(bar)
        self.navigationBar = bar
        self.layoutIfNeeded()
    }
    
    func clearAll() {
        self.contentView?.removeFromSuperview()
        self.scrollView?.removeFromSuperview()
        self.tableView?.removeFromSuperview()
        self.collectionView?.removeFromSuperview()
        self.contentView = nil
        self.scrollView = nil
        self.tableView = nil
        self.layoutIfNeeded()
    }
    
    public func addScrollView(_ scrollViewHandler: (UIScrollView) -> Void) {
        self.clearAll()
        let scrollview = UIScrollView(frame: .zero)
        scrollview.restorationIdentifier = "scrollview"
        placementView.addSubview(scrollview)
        scrollview.isDirectionalLockEnabled = true
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        ///scrollview constraint
        let topConstraint = NSLayoutConstraint(item: scrollview,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: placementView,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: navigationBarHeight + navigationBarOffset)
        let rightConstraint = NSLayoutConstraint(item: scrollview,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: placementView,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        let leftConstraint = NSLayoutConstraint(item: scrollview,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: placementView,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: scrollview,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: placementView,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 0)
        
        placementView.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        self.layoutIfNeeded()
        scrollView = scrollview
        scrollViewHandler(scrollview)
        
    }
    
    // add collection view 
    public func addCollectionView(flowLayout: UICollectionViewFlowLayout? = nil , _ collectionViewHandler: (UICollectionView, UIScrollView) -> Void) {
        addScrollView({scrollview in
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            scrollview.addSubview(stackView)
            let _topConstraint = NSLayoutConstraint(item: stackView,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: scrollview,
                                                    attribute: .top,
                                                    multiplier: 1,
                                                    constant: 0)
            let _rightConstraint = NSLayoutConstraint(item: stackView,
                                                      attribute: .right,
                                                      relatedBy: .equal,
                                                      toItem: scrollview,
                                                      attribute: .right,
                                                      multiplier: 1,
                                                      constant: 0)
            let _leftConstraint = NSLayoutConstraint(item: stackView,
                                                     attribute: .left,
                                                     relatedBy: .equal,
                                                     toItem: scrollview,
                                                     attribute: .left,
                                                     multiplier: 1,
                                                     constant: 0)
            let _bottomConstraint = NSLayoutConstraint(item: stackView,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                       toItem: scrollview,
                                                       attribute: .bottom,
                                                       multiplier: 1,
                                                       constant: 0)
            
            let _heightConstraint = stackView.heightAnchor.constraint(equalTo: scrollview.heightAnchor, multiplier: 1.0)
            let _widthConstraint = stackView.widthAnchor.constraint(equalTo: scrollview.widthAnchor, multiplier: 1.0)
            _heightConstraint.priority = .defaultLow
            
            let collectionview: UICollectionView
            if let layout = flowLayout {
                collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
            } else {
                let l = UICollectionViewFlowLayout()
                collectionview = UICollectionView(frame: .zero, collectionViewLayout: l)
            }
            
            collectionview.restorationIdentifier = "collectionview"
            collectionview.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(collectionview)
            
            
            scrollview.delegate = self
            
            
            
            scrollview.addConstraints([_topConstraint, _leftConstraint, _rightConstraint, _bottomConstraint, _heightConstraint, _widthConstraint])
            
            collectionViewHeightConstraint = collectionview.heightAnchor.constraint(equalToConstant: collectionview.collectionViewLayout.collectionViewContentSize.height)
            collectionViewHeightConstraint?.isActive = true
            
            self.collectionView = collectionview
            collectionViewHandler(collectionview, scrollview)
            
            collectionview.reloadData()
            self.layoutIfNeeded()
            
            let height = collectionview.collectionViewLayout.collectionViewContentSize.height + collectionview.contentInset.top + collectionview.contentInset.bottom
            if initialHeight == CGFloat.adjustWithTableviewContent {
                
                self.initialHeight = height + self.navigationBarHeight + (2 * self.navigationBarOffset)
                self.collectionViewHeightConstraint?.constant = height
                self.bottomSheetHeightConstraint.constant = (self.initialHeight < maxHeight) ? self.initialHeight : maxHeight
                UIView.animate(withDuration: 0.2, animations: {
                    self.layoutIfNeeded()
                })
            } else {
                if isExpandableToFullHeight {
                    collectionViewHeightConstraint?.constant = height
                    collectionView?.isScrollEnabled = false
                    scrollView?.isScrollEnabled = false
                    
                } else {
                    collectionViewHeightConstraint?.constant = initialHeight - navigationBarHeight - navigationBarOffset
                    collectionView?.isScrollEnabled = true
                    scrollView?.isScrollEnabled = false
                    self.layoutIfNeeded()
                }
            }
            
            
        })
    }
    
    public func addTableView(_ tableViewHandler: (UITableView, UIScrollView) -> Void) {
        addScrollView({scrollview in
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            scrollview.addSubview(stackView)
            let _topConstraint = NSLayoutConstraint(item: stackView,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: scrollview,
                                                    attribute: .top,
                                                    multiplier: 1,
                                                    constant: 0)
            let _rightConstraint = NSLayoutConstraint(item: stackView,
                                                      attribute: .right,
                                                      relatedBy: .equal,
                                                      toItem: scrollview,
                                                      attribute: .right,
                                                      multiplier: 1,
                                                      constant: 0)
            let _leftConstraint = NSLayoutConstraint(item: stackView,
                                                     attribute: .left,
                                                     relatedBy: .equal,
                                                     toItem: scrollview,
                                                     attribute: .left,
                                                     multiplier: 1,
                                                     constant: 0)
            let _bottomConstraint = NSLayoutConstraint(item: stackView,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                       toItem: scrollview,
                                                       attribute: .bottom,
                                                       multiplier: 1,
                                                       constant: 0)
            
            let _heightConstraint = stackView.heightAnchor.constraint(equalTo: scrollview.heightAnchor, multiplier: 1.0)
            let _widthConstraint = stackView.widthAnchor.constraint(equalTo: scrollview.widthAnchor, multiplier: 1.0)
            _heightConstraint.priority = .defaultLow
            
            let tableview = UITableView(frame: .zero)
            tableview.estimatedRowHeight = 0
            tableview.restorationIdentifier = "tableview"
            tableview.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(tableview)
            
            tableview.isScrollEnabled = false
            scrollview.delegate = self
            scrollview.isScrollEnabled = true
            
            self.tableView = tableview
            
            tableViewHandler(tableview, scrollView!)
            
            scrollview.addConstraints([_topConstraint, _leftConstraint, _rightConstraint, _bottomConstraint, _heightConstraint, _widthConstraint])
            
            tableViewHeightConstraint = tableview.heightAnchor.constraint(equalToConstant: tableview.contentSize.height)
            tableViewHeightConstraint?.isActive = true
            
            tableview.reloadData()
            self.layoutIfNeeded()
            
            if initialHeight == CGFloat.adjustWithTableviewContent {
                self.initialHeight = tableview.contentSize.height + self.navigationBarHeight + (2 * self.navigationBarOffset)
                self.tableViewHeightConstraint?.constant = tableview.contentSize.height
                self.bottomSheetHeightConstraint.constant = self.initialHeight
                UIView.animate(withDuration: 0.2, animations: {
                    self.layoutIfNeeded()
                })
            } else {
                tableViewHeightConstraint?.constant = (tableview.contentSize.height < maxHeight) ? (maxHeight - navigationBarHeight - 24) : tableview.contentSize.height
            }
            
        })
    }
    
    func presentView(parent: UIViewController) {
        parentViewController = parent
        parentViewController.view.addSubview(self)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetHeightConstraint = self.heightAnchor.constraint(equalToConstant: self.initialHeight)
        bottomSheetHeightConstraint.isActive = true
        
        self.bottomAnchor.constraint(equalTo: parentViewController.view.bottomAnchor).isActive = true
        
        self.leadingAnchor.constraint(equalTo: parentViewController.view.leadingAnchor).isActive = true
        
        self.trailingAnchor.constraint(equalTo: parentViewController.view.trailingAnchor).isActive = true
        
        self.layoutIfNeeded()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    public func addContentView(_ contentViewHandler: @escaping (UIView) -> Void) {
        
        self.clearAll()
        
        let content = UIView(frame: .infinite)
        content.restorationIdentifier = "contentview"
        self.placementView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = NSLayoutConstraint(item: content,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: placementView,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: content,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: placementView,
                                                   attribute: .leading,
                                                   multiplier: 1.0,
                                                   constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: content,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: placementView,
                                                    attribute: .trailing,
                                                    multiplier: 1.0,
                                                    constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: content,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: placementView,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: navigationBarHeight + navigationBarOffset)
        
        
        NSLayoutConstraint.activate([bottomConstraint, leadingConstraint, trailingConstraint, topConstraint])
        
        self.layoutIfNeeded()
        
        self.contentView = content
        
        contentViewHandler(content)
        
        
    }
    
    public func addBottomSheetView(view: UIView, presentedView viewHandler: (UIView) -> Void) {
        
        let placementView = view
        self.addSubview(placementView)
        placementView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: placementView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: placementView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: placementView,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .leading,
                                                   multiplier: 1.0,
                                                   constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: placementView,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .trailing,
                                                    multiplier: 1.0,
                                                    constant: 0)
        
        
        
        self.addConstraints([bottomConstraint, leadingConstraint, trailingConstraint, topConstraint])
        self.layoutIfNeeded()
        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(gesture:)))
        self.addGestureRecognizer(dragGesture)
        
        viewHandler(self)
        self.placementView = placementView
    }
    
    @objc func onBackgroundTapped() {
        self.close()
    }
    
    func close() {
        guard self.isClosable else {
            return
        }
        if type == .View {
            self.removeFromSuperview()
        } else {
            self.parentViewController.dismiss(animated: false, completion: nil)
        }
        
    }
    
    func addGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped))
    }
    
    @objc func onPan(gesture: UIPanGestureRecognizer) {
        
        let minimumHeight = CGFloat(initialHeight)
        
        let v = gesture.view
        let t = gesture.translation(in: v)
        let offsetY = t.y
        let trans = self.bottomSheetHeightConstraint.constant - offsetY
        if gesture.state == UIGestureRecognizer.State.began || gesture.state == UIGestureRecognizer.State.changed {
            if trans < self.maxHeight {
                if trans > minimumHeight {
                    if !self.isExpandableToFullHeight {
                        return
                    }
                }
                
                self.bottomSheetHeightConstraint.constant = trans
                
                if trans > (minimumHeight + 100) {
                    if gesture.velocity(in: v).y < 0 {
                        self.state = .FullPresented
                    }
                }
                
                self.layoutIfNeeded()
                gesture.setTranslation(CGPoint(x: t.x, y: 0), in: v)
                
            }
            
        } else {
            panSheet(offset: -offsetY)
            gesture.setTranslation(CGPoint(x: t.x, y: 0), in: v)
        }
    }
    
    
    func panSheet(offset: CGFloat) {
    
        let minimumHeight = CGFloat(initialHeight)
        let trans = self.bottomSheetHeightConstraint.constant + offset
        
        if trans < 0 || trans > maxHeight {
            return
        }
        
        if trans <= (minimumHeight - (minimumHeight / 2.0)) && trans >= (navigationBarHeight) {
            if enableClipToBar {
                self.state = .BarOnlyPresented
            } else {
                self.state = .Hidden
            }
        } else if trans < (navigationBarHeight) {
            if enableClipToBar {
                self.state = .BarOnlyPresented
            } else {
                self.state = .HalfPresented
            }
            self.state = .Hidden
        }
        else if trans > (minimumHeight - (minimumHeight / 2.0)) && trans < minimumHeight {
            self.state = .HalfPresented
        } else if trans <= (maxHeight - (maxHeight / 10.0))  && trans >= minimumHeight {
            self.state = .HalfPresented
        } else if trans > (maxHeight - (maxHeight / 10.0)) {
            if isExpandableToFullHeight {
                self.state = .FullPresented
            } else {
                self.state = .HalfPresented
            }
            
        } else {
            
        }
    }
}

//MARK: SCROLL VIEW DELEGATE
extension UISheetView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let trans = bottomSheetHeightConstraint.constant + scrollView.contentOffset.y
        if trans < self.maxHeight {
            let vel = scrollView.panGestureRecognizer.velocity(in: scrollView)
            if vel.y > 0 {
                if scrollView.contentOffset.y >= 0 {
                    scrollView.contentOffset.y = 0
                    return
                } else {
                    self.onPan(gesture: scrollView.panGestureRecognizer)
                }
            }
            scrollView.contentOffset.y = 0
        }
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if bottomSheetHeightConstraint.constant != self.maxHeight && bottomSheetHeightConstraint.constant != initialHeight {
            self.panSheet(offset: -scrollView.contentOffset.y)
        }
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if bottomSheetHeightConstraint.constant != self.maxHeight && bottomSheetHeightConstraint.constant != initialHeight {
            self.panSheet(offset: -scrollView.contentOffset.y)
        }
    }
}

fileprivate extension UIView {
    var allSubviews: [UIView] {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
}
