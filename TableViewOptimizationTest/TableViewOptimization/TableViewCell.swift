//
//  TableViewCell.swift
//  TableViewOptimization
//
//  Created by Bondar Yaroslav on 29.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var someImage: UIImageView!
    @IBOutlet weak var label: ShadowLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

//cell optimization

class SimpleColCell: UICollectionViewCell {
    
    @IBOutlet weak var someLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        someLabel.backgroundColor = UIColor.clear
        someLabel.layer.backgroundColor = UIColor.white.cgColor
        
        someLabel.layer.cornerRadius = 5
        //        someLabel.layer.masksToBounds = false
        
        //        someLabel.frame = someLabel.frame.integral
        //        ceilf(10)
        //        floorf(40)
        
        //        someLabel.layer.drawsAsynchronously = true
        
        //        someLabel.layer.shouldRasterize = true
        //        someLabel.layer.rasterizationScale = UIScreen.main.scale
    }
}

