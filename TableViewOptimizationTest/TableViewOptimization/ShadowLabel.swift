//
//  ShadowLabel.swift
//  TableViewOptimization
//
//  Created by Bondar Yaroslav on 12.01.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ShadowLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        
        //        cell.label.layer.shadowOffset = CGSize(width: 0, height: 5)
        //        cell.label.layer.shadowOpacity = 0.5
        
//        layer.backgroundColor = backgroundColor?.cgColor
//        backgroundColor = UIColor.clear
        
        //        cell.label.layer.shouldRasterize = true
        //        cell.label.layer.rasterizationScale = UIScreen.main.scale
        
        
        
        let myShadowOffset = CGSize(width: 2, height: 2)
        let myColorValues: [CGFloat] = [0, 0, 0, 0.8]
        let myContext = UIGraphicsGetCurrentContext()!
        myContext.saveGState()
        let myColorSpace = CGColorSpaceCreateDeviceRGB()
        let myColor = CGColor(colorSpace: myColorSpace, components: myColorValues)!
        myContext.setShadow(offset: myShadowOffset, blur: 3, color: myColor)
        super.drawText(in: rect)
        //        CGColorRelease(myColor)
        myContext.restoreGState()
    }
}
