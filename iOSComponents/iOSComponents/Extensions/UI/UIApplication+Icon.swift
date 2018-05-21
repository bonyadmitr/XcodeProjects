//
//  UIApplication+Icon.swift
//  AlternateIcon
//
//  Created by Bondar Yaroslav on 13/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIApplication {
    var appIcon: UIImage? {
        guard
            let bundleIcons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
            let prima‌​ryIcon = bundleIcons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconsArray = prima‌​ryIcon["CFBundleIconFiles"] as? [String],
            let name = iconsArray.last
            else { return nil }
        
        return UIImage(named: name) /// or "AppIcon60x60"
    }
}
