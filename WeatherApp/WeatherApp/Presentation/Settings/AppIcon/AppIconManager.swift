//
//  AppIconManager.swift
//  AlternateIcon
//
//  Created by Bondar Yaroslav on 13/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Control app icon
class AppIconManager {
    
    /// singleton
    static let shared = AppIconManager()
    
    /// current selected app icon
    var currentIcon = AppIcon.primary
    
    /// genereate new UIImages every get time
    var icons: [UIImage] {
        return AppIcon.allValues.map { $0.image }
    }
    
    /// /// change app icon from AppIcon enum
    ///
    /// - Parameters:
    ///   - icon: icon from AppIcon
    ///   - withAlert: show system alert that changed icon
    ///   - success: complition handler
    @available(iOS 10.3, *)
    func change(to icon: AppIcon, withAlert: Bool = false, success: (() -> Void)? = nil) {
        
        guard UIApplication.shared.supportsAlternateIcons else {
            return print("supportsAlternateIcons == false")
        }
        
        UIApplication.shared.setAlternateIconName(icon.name) { error in
            if let error = error {
                print("setAlternateIconName error:", error.localizedDescription)
            } else {
                self.currentIcon = icon
                success?()
            }
        }
        
        if !withAlert {
            let tempViewController = UIViewController()
            
            UIApplication.shared.windows.last?.rootViewController?
                .present(tempViewController, animated: false, completion: {
                tempViewController.dismiss(animated: false, completion: nil)
            })
        }

    }
}
