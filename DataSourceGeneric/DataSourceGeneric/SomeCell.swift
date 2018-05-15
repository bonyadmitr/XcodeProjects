//
//  SomeCell.swift
//  DataSourceGeneric
//
//  Created by Bondar Yaroslav on 20/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class SomeCell: FillableCell<SomeEntity> {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func fill(with object: SomeEntity) {
        titleLabel.text = object.title
        nameLabel.text = object.name
    }
}
