//
//  DetailController.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        titleLabel.text = text
    }
    
    @IBAction private func showSubDetail(_ sender: UIButton) {
        performSegue(withIdentifier: "subdetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue.identifier == "subdetail",
        if let vc = segue.destination as? SubDetailController {
            vc.text = text
        }
    }
}
