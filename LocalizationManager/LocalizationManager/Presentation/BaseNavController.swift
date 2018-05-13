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
        // FIXME: this don't change push direction for RTL. Recreating of UINavigationController can help
        /// https://github.com/marmelroy/Localize-Swift can't do that
        navigationItem.lzTitle = "hello"
        viewControllers[0] = storyboard!.instantiateViewController(withIdentifier: "ViewController")
        UIApplication.shared.animateReload()
    }
}
