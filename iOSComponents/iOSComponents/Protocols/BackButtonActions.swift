//
//  BackButtonActions.swift
//  Interview
//
//  Created by Bondar Yaroslav on 5/21/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol BackButtonActions {
    
}
extension BackButtonActions where Self: UIViewController {
    func removeBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

/// or
//extension UIViewController {
//    func removeBackButtonTitle() {
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//    }
//}
