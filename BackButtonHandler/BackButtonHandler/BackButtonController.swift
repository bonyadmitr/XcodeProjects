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
        
        
//        let backBTN = UIBarButtonItem(image: UIImage(named: "Icon-Back"),
//                                      style: .plain,
//                                      target: navigationController,
//                                      action: #selector(UINavigationController.popViewController(animated:)))
//        navigationItem.leftBarButtonItem = backBTN
        
        
        
        navigationItem.leftBarButtonItem = BackButtonItem(title: previousNavigationVCTitle(), action: { [weak self] in
            let vc = UIAlertController(title: "Exit without save?", message: nil, preferredStyle: .actionSheet)
            vc.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                self?.navigationController?.popViewController(animated: true)
            })
            vc.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self?.present(vc, animated: true, completion: nil)
        })
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let vc = UIViewController()
//            vc.view.backgroundColor = .red
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
    deinit {
        print("- deinit BackButtonController")
    }
    
}
