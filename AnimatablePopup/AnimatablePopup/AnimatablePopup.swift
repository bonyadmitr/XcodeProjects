//
//  AnimatablePopup.swift
//  AnimatablePopup
//
//  Created by Bondar Yaroslav on 3/22/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

typealias VoidHandler = () -> Void

private enum Constants {
    static let minScaleTransform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
    static let animationDuration = 0.3
}

protocol AnimatablePopup: class {
    var containerView: UIView! { get }
    var shadowView: UIView? { get }
    var isShown: Bool { get set }
}

extension AnimatablePopup {
    func open() {
        if isShown {
            return
        }
        isShown = true
        containerView.transform = Constants.minScaleTransform
        shadowView?.alpha = 0
        UIView.animate(withDuration: Constants.animationDuration) {
            self.shadowView?.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    func close(completion: (() -> Void)? = nil) {
        animateClose(completion: completion)
    }
    
    private func animateClose(completion: VoidHandler? = nil) {
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.shadowView?.alpha = 0
            self.containerView.transform = Constants.minScaleTransform
        }, completion: { _ in
            self.isShown = false
            completion?()
        })
    }
}

extension AnimatablePopup where Self: UIViewController {
    var shadowView: UIView? {
        return view
    }
    
    func close(completion: VoidHandler? = nil) {
        animateClose(completion: {
            self.dismiss(animated: false, completion: completion)
        })
    }
}

extension AnimatablePopup where Self: UIView {
    var containerView: UIView! {
        return self
    } 
    var shadowView: UIView? {
        return nil
    }
}
