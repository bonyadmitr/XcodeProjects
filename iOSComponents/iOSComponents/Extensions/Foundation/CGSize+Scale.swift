//
//  CGSize+Scale.swift
//  LifeboxShared
//
//  Created by Bondar Yaroslav on 3/1/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import UIKit

extension CGSize {
    var screenScaled: CGSize {
        return self * UIScreen.main.scale
    }
    
    static func * (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(width: left.width * right, height: left.height * right)
    }
}
