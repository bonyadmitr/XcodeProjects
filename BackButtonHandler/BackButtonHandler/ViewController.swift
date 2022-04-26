//
//  ViewController.swift
//  BackButtonHandler
//
//  Created by Bondar Yaroslav on 2/16/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class TableVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// to test BackButtonItem
        //performSegue(withIdentifier: "backButton", sender: nil)
        
        
        /// clear back button title
//        if #available(iOS 14.0, *) {
//            navigationItem.backButtonDisplayMode = .minimal
//        }
        
        /// clear back button title
//        if #available(iOS 11.0, *) {
//            navigationItem.backButtonTitle = ""
//        }
        
        /// clear back button title
        //navigationItem.backBarButtonItem = UIBarButtonItem()
        
        
        /// custom title
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: nil, action: nil)
        
        /// custom title
        //navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
    }
}






final class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearBackButtonHandler()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewWillDisappearBackButtonHandler()
    }
}

extension ViewController: BackButtonHandler {
    func shouldPopOnBackButton(_ handler: @escaping BoolHandler) {
        let vc = UIAlertController(title: "Exit without save?", message: nil, preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            handler(true)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            handler(false)
        }
        vc.addAction(yesAction)
        vc.addAction(noAction)
        present(vc, animated: true, completion: nil)
    }
}


