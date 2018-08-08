//
//  SubDetailController.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// don't use "show detail" segue for subdetail controllers with navigation controller.
/// it will ignore navigation controller and will replace it 
class SubDetailController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// don't use next code for subdetail controllers
        /// "navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem"
        /// it is not convenient with back button
        navigationItem.rightBarButtonItem = splitViewController?.displayModeButtonItem
        
        navigationItem.leftItemsSupplementBackButton = true
        
        titleLabel.text = text
    }
}
