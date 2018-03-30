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
    
    /// Enum of icons that you must change
    enum AppIcon: String {
        case primary
        case adn
        case home
        case soccer
        
        /// all enum values
        static let allValues = [primary, adn, home, soccer]
        
        /// get name for UIApplication.shared.setAlternateIconName
        /// primary must be nil
        var name: String? {
            switch self {
            case .primary:
                return nil
            default:
                return self.rawValue
            }
        }
        
        /// get UIImage from enum
        var image: UIImage {
            switch self {
            case .primary:
                return UIApplication.shared.mainAppIcon!
            default:
                return UIImage(named: self.rawValue)!
            }
        }
    }
    
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
    ///   - success: complition handler
    @available(iOS 10.3, *)
    func `switch`(to icon: AppIcon, withAlert: Bool = false, success: (() -> Void)? = nil) {
        
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
