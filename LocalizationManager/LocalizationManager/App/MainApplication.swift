//
//  MainApplication.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 5/12/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class MainApplication: UIApplication, UIApplicationDelegate {
    
    /// need for right direction of interactivePopGestureRecognizer in navigationController
    /// called for every view
    /// https://stackoverflow.com/a/49646499/5893286
    override var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        if LocalizationManager.shared.isCurrentLanguageRTL {
            return .rightToLeft
        }
        return .leftToRight
    }
}
