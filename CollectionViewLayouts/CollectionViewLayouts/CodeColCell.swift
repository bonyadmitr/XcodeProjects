//
//  CodeColCell.swift
//  CollectionViewLayouts
//
//  Created by Bondar Yaroslav on 12.01.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

let codeColCellId = String(describing: CodeColCell.self)

class CodeColCell: UICollectionViewCell {
    
    var someLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        someLabel = UILabel()
        someLabel.backgroundColor = UIColor.clear
        someLabel.layer.backgroundColor = UIColor.white.cgColor
        someLabel.textAlignment = .center
        
        someLabel.layer.cornerRadius = 5
        addSubview(someLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        someLabel.frame = bounds
    }
}
