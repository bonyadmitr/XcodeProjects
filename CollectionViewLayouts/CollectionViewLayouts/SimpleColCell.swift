//
//  SimpleColCell.swift
//  CollectionViewLayouts
//
//  Created by Bondar Yaroslav on 09.01.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

var simpleColCellID = "SimpleColCell"

class SimpleColCell: UICollectionViewCell {
    
    @IBOutlet weak var someLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        someLabel.backgroundColor = UIColor.clear
        someLabel.layer.backgroundColor = UIColor.white.cgColor
        someLabel.layer.cornerRadius = 5
    }
}
