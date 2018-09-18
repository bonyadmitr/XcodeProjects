//
//  EventCollectionCell.swift
//  FetchedResultsController
//
//  Created by Bondar Yaroslav on 9/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class EventCollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var textLabel: UILabel?
    @IBOutlet private weak var detailTextLabel: UILabel?
    
    func fill(with event: EventDB) {
        textLabel?.text = event.title
        detailTextLabel?.text = event.date?.description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
    }
}
