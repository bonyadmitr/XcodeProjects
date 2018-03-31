//
//  BaseNavController.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 2/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class BaseNavController: UINavigationController {
    override func awakeFromNib() {
        super.awakeFromNib()   
        LocalizationManager.shared.register(self)
    }
}
extension BaseNavController: LocalizationManagerDelegate {
    func languageDidChange(to language: String) {
        print(language)
        navigationItem.lzTitle = "hello"
        viewControllers[0] = storyboard!.instantiateViewController(withIdentifier: "ViewController")
        UIApplication.shared.animateReload()
    }
}
