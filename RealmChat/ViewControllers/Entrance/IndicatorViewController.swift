//
//  IndicatorViewController.swift
//  RealmChat
//
//  Created by Ueoka Kazuya on 2016/10/16.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

class IndicatorViewController: UIViewController {
    private lazy var backgroundView: UIView = {
        let backgroundView: UIView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 12.0
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isHidden = true
        return backgroundView
    }()
    private func setupBackgroundViewConstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.backgroundView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.backgroundView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.backgroundView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 200.0),
            NSLayoutConstraint(item: self.backgroundView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 200.0)
        ])
    }
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    private func setupIndicatorViewConstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.indicatorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.indicatorView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.indicatorView)
        
        self.setupBackgroundViewConstraint()
        self.setupIndicatorViewConstraint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.start()
    }
    
    func start() {
        self.backgroundView.isHidden = false
        if !self.indicatorView.isAnimating {
            self.indicatorView.startAnimating()
        }
    }
    
    func stop() {
        self.backgroundView.isHidden = true
        if self.indicatorView.isAnimating {
            self.indicatorView.stopAnimating()
        }
    }
}
