//
//  UISearchBar+Cancel.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 5/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UISearchBar {
    func enableCancelButton() {
        for view in subviews {
            for subview in view.subviews {
                if let button = subview as? UIButton {
                    button.isEnabled = true
                }
            }
        }
    }
}


// TODO: create new extensions
//if let subviews = searchBar.subviews.first?.subviews {
//    subviews.forEach({ subview in
//        if subview is UITextField {
//            searchTextField = subview as? UITextField
//            searchTextField?.backgroundColor = ColorConstants.searchBarColor
//            searchTextField?.placeholder = TextConstants.search
//            searchTextField?.font = UIFont.TurkcellSaturaBolFont(size: 19)
//            searchTextField?.textColor = ColorConstants.darcBlueColor
//            searchTextField?.keyboardAppearance = .dark
//        }
//        if subview is UIButton {
//            (subview as! UIButton).titleLabel?.font = UIFont.TurkcellSaturaRegFont(size: 17)
//            (subview as! UIButton).isEnabled = true
//        }
//    })
//}
