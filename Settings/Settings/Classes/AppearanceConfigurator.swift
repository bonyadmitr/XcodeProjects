//
//  AppearanceConfigurator.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 18/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// I didn't find a way to localize standart buttons like "done", "cancel" without app restrart
// sp don't use them. Simply write title "done" and addd translation to Localizable.strings
class AppearanceConfigurator {
    
    static let shared = AppearanceConfigurator()
    
    func configureLocalizedAppearance() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).lzTitle = "cancel"
    }
}
