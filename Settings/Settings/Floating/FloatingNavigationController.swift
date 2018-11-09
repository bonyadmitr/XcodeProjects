//
//  FloatingNavigationController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 10/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

#if DEBUG
import UIKit

final class FloatingNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        let leftButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(exit))
        rootViewController.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func exit() {
        Floating.isShownOnShake = false
        dismiss(animated: true, completion: nil)
    }
}
#endif
