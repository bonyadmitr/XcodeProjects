//
//  UIImage+RTL.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 5/13/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIImage {
    var flippedForRTL: UIImage {
        if #available(iOS 10.0, *) {
            return withHorizontallyFlippedOrientation()
        } else {
            return imageFlippedForRightToLeftLayoutDirection()
        }
    }
    
    var flippedForRTLIfNeed: UIImage {
        if LocalizationManager.shared.isCurrentLanguageRTL {
            return flippedForRTL
        } else {
            return self
        }
    }
}
