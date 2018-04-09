//
//  BackButtonController.swift
//  BackButtonHandler
//
//  Created by Bondar Yaroslav on 09/04/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class BackButtonController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// nothing is working
//        self.navigationController?.navigationBar.backIndicatorImage = image
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
//        navigationItem.backBarButtonItem

        
        navigationItem.leftBarButtonItem = BackButtonItem(action: {
            
            let vc = UIAlertController(title: "Exit without save?", message: nil, preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            vc.addAction(yesAction)
            vc.addAction(noAction)
            self.present(vc, animated: true, completion: nil)
        })
    }
}
