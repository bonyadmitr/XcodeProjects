//
//  UIButton+Color.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 12/13/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        let image = UIImage(color: color)
        setRoundedBackgroundImage(image: image, for: state)
    }
    
    private func setRoundedBackgroundImage(image: UIImage?, for state: UIControlState) {
        guard clipsToBounds || layer.cornerRadius != 0 else {
            setBackgroundImage(image, for: state)
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1.0);
        UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).addClip()
        image?.draw(in: bounds)
        let clippedBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        setBackgroundImage(clippedBackgroundImage, for: state)
    }
}
