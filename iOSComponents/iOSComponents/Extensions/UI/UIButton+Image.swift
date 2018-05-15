//
//  UIButton+Image.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 5/15/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import UIKit

extension UIButton {
    /// https://stackoverflow.com/a/43785519/5893286
    func forceImageToRightSide() {
        /// or 1
        let newTransform = CGAffineTransform(scaleX: -1.0, y: 1.0) 
        transform = newTransform
        titleLabel?.transform = newTransform
        imageView?.transform = newTransform
        
        /// or 2
        //sortByButton.semanticContentAttribute = .forceRightToLeft
    }
}
