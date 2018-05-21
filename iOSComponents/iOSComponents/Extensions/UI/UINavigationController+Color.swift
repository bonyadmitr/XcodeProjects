//
//  UINavigationController+Color.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 09.08.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import UIKit

//usefull for UIImagePickerController
extension UINavigationController {
    
    var backgroundColor: UIColor? {
        set { navigationBar.barTintColor = newValue }
        get { return navigationBar.barTintColor }
    }
    
    var textColor: UIColor {
        set { view.tintColor = newValue }
        get { return view.tintColor }
    }
    
    var barStyle: UIBarStyle {
        set { navigationBar.barStyle = newValue }
        get { return navigationBar.barStyle }
    }
}