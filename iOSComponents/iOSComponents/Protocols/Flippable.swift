//
//  Flippable.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol Flippable: class {
    var front: UIView! { get }
    var back: UIView! { get }
    var isFront: Bool { get set }
    func flipCell()
}

extension Flippable where Self: UIView {
    
    //var isFront: Bool {
    //return true
    //}
    
    func flipCell() {
        
        if isFront {
            UIView.transition(with: self, duration: 1, options: .transitionFlipFromLeft, animations: {
                self.front.isHidden = true
                self.back.isHidden = false
            }, completion: nil)
            
        } else {
            UIView.transition(with: self, duration: 1, options: .transitionFlipFromRight, animations: {
                self.front.isHidden = false
                self.back.isHidden = true
            }, completion: nil)
        }
        
        isFront = !isFront
    }
}
