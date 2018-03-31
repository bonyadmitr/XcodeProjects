//
//  PopupView.swift
//  AnimatablePopup
//
//  Created by Bondar Yaroslav on 3/22/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class PopupView: UIView, AnimatablePopup {
    var isShown = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
        layer.cornerRadius = 5
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        center = view.center
        open()
    }
    
    @IBAction func actionCloseButton(_ sender: UIButton) {
        close() {
            self.removeFromSuperview()
            print("closed popup")
        }
    }
}
