//
//  UIViewController+Present.swift
//  Swift3Best
//
//  Created by Bondar Yaroslav on 21/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Usage

//let vc = UIViewController()
//@IBAction func actionShowButton(_ sender: UIButton) {
//    vc.view.backgroundColor = UIColor.red
//    presentInNavVc(vc, doneAction: #selector(doneAction))
//}
//
//func doneAction() {
//    vc.dismissSelf()
//}

extension UIViewController {
    
    func presentInNavVc(_ controller: UIViewController, doneAction: Selector? = nil) {
        
        let nvc = UINavigationController(rootViewController: controller)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(dismissSelf))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: doneAction)
        controller.navigationItem.leftBarButtonItem = cancelButton
        controller.navigationItem.rightBarButtonItem = doneButton
        present(nvc, animated: true, completion: nil)
    }
}
