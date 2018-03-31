//
//  SeasonCell.swift
//  GenericTableViewController
//
//  Created by zdaecqze zdaecq on 03.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class SeasonCell: UITableViewCell, NibCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    
    func config(with season: Season) {
        titleLabel.text = season.title
        indexLabel.text = "\(season.number)"
    }
}
