//
//  ChildViewController.swift
//  Pods-ZBottomSheet_Example
//
//  Created by sudansuwal on 8/21/20.
//

import UIKit

public class ChildViewController: UIViewController {
    
    var sheetView: UISheetView!
    var background: UIView = UIView()
    var tapGesture: UITapGestureRecognizer!

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupGesture()
        sheetView.presentView(parent: self)
    }
    
    //add background layer
    func setupBackgroundView() {
        background = UIView(frame: self.view.frame)
        self.view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: background, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: background, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: background, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: background, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
        ])
        background.backgroundColor = .black
        background.alpha = 0.1
        
    }

    func setupGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        background.addGestureRecognizer(tapGesture)
    }

    @objc func onTap() {
        sheetView.state = .Hidden
    }
}
