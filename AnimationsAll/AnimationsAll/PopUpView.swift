//
//  PopUpView.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 27.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

open class PopUpView: UIView {
    
    open var animationTime = 0.3
    open var animatedScale: CGFloat = 1.3
    
    open var topConstraintConstant: CGFloat = 0 // { didSet { popUpView.topConstraintConstant = -64 } }
    
    open var isBackgroundHideTapGesture = true
    open var backgroundPopUpColor: UIColor? = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    
    private let backgroundView = UIView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        
        backgroundView.backgroundColor = backgroundPopUpColor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopUp))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func addBackgroundView(to view: UIView) {
        view.addSubview(backgroundView)
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func addSelf(to view: UIView) {
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: topConstraintConstant).isActive = true
    }
    
    open func show(in view: UIView) {
        if isBackgroundHideTapGesture {
            addBackgroundView(to: view)
        }
        addSelf(to: view)
        
        self.alpha = 0
        self.backgroundView.alpha = 0
        self.transform = CGAffineTransform(scaleX: animatedScale, y: animatedScale)
        UIView.animate(withDuration: animationTime) {
            self.alpha = 1
            self.backgroundView.alpha = 1
            self.transform = CGAffineTransform.identity
        }
    }
    
    @objc open func hidePopUp() {
        self.alpha = 1
        self.backgroundView.alpha = 1
        self.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: animationTime, animations: {
            self.alpha = 0
            self.backgroundView.alpha = 0
            self.transform = CGAffineTransform(scaleX: self.animatedScale, y: self.animatedScale)
        }, completion: { _ in
            self.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        })
    }
}
