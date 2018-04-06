//
//  Flippable.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol Flippable: class {
    var frontView: UIView! { get }
    var backView: UIView! { get }
    var isFront: Bool { get set }
    func flipCell()
}

extension Flippable where Self: UIView {
    
    func flipCell() {
        if isFront {
            UIView.transition(with: self, duration: 1, options: .transitionFlipFromLeft, animations: {
                self.frontView.isHidden = true
                self.backView.isHidden = false
            }, completion: nil)
            
        } else {
            UIView.transition(with: self, duration: 1, options: .transitionFlipFromRight, animations: {
                self.frontView.isHidden = false
                self.backView.isHidden = true
            }, completion: nil)
        }
        
        isFront = !isFront
    }
}
