//
//  AppearanceManager.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 23/03/2017.
//  Copyright © 2017 sMediaLink. All rights reserved.
//

import UIKit

/// maybe
//func configure(_ navigationBar: UINavigationBar) {
//}

struct AppearanceManager {
    
    static let shared = AppearanceManager()
    
    func configurateAll() {
        
        /// need View controller-based status bar appearance = NO in Info.plist
        UIApplication.shared.statusBarStyle = .lightContent
        
        /// color of all buttons text (tintColor)
        /// can be overriden by doneButton.tintColor = UIColor.cyan
        /// or any other appearance()
//        UIApplication.shared.delegate?.window??.tintColor = Colors.main

        removeAllBackButtonTitles()
        configureNavigationBar()
        configureBarButtonItem()
        configureSearchBar()
        configure(tableView: UITableView.appearance())
    }
    
    /// we need this one for immediately translation
    /// standart buttons isn't translated immediately
    func configureLocalizedAppearance() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).lzTitle = "cancel"
    }
    
    /// remove all back button titles
    /// https://stackoverflow.com/questions/29912489/how-to-remove-all-navigationbar-back-button-title
    func removeAllBackButtonTitles() {
        let offset = UIOffset(horizontal: 0, vertical: -60)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(offset, for:.default)
    }
    
//    func configureNavigationItem() {
//        
//    }
    
    /// Need to customize and use instead of subclasses
    func configureNavigationBar() {
        
        /// don't work if View controller-based status bar appearance = NO in Info.plist
        /// can be edited by:
        /// override func viewDidLoad() {
        ///     navigationController?.navigationBar.barStyle = .default
        /// }
        /// but it will change status bar color for all controller in that navigationController
//        UINavigationBar.appearance().barStyle = .black
        
        
        /// back button
        //        UINavigationBar.appearance().backIndicatorImage
        //        UINavigationBar.appearance().backIndicatorTransitionMaskImage

        
        ///
        UINavigationBar.appearance().isTranslucent = false
        
        /// bar's background color
        UINavigationBar.appearance().barTintColor = Colors.main
        UINavigationBar.appearance().backgroundColor = Colors.main
        
        /// bar's buttons color
        UINavigationBar.appearance().tintColor = Colors.text
        
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: Fonts.base.font(with: 20),
            NSAttributedStringKey.foregroundColor: Colors.text
        ]
        
        /// shadow line off.
        /// need: UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        /// full transparent
        //UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        //UINavigationBar.appearance().shadowImage = UIImage()
        //UINavigationBar.appearance().backgroundColor = UIColor.clear
        //UINavigationBar.appearance().isTranslucent = true
    }
    
    func configureBarButtonItem() {
        let attr: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: Fonts.base.font(with: 18)]
//                                   NSForegroundColorAttributeName: Colors.text
        UIBarButtonItem.appearance().setTitleTextAttributes(attr, for: .normal)
        
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.green
        
        /// don't work for UIBarButtonItem in navigation bar
        /// need UINavigationController and it's subclass
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [ViewController.self]).tintColor = UIColor.orange
    }
    
    
    func configureSearchBar() {
        
        /// cursor, buttons and others subviews color
        UISearchBar.appearance().tintColor = Colors.text
        
        /// out of textField color activated
        UISearchBar.appearance().barTintColor = Colors.main
        
        /// cursor only color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = Colors.main
        
        /// text color
        UISearchBar.appearance().textColor = Colors.main
        
        /// text font
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.font.rawValue: Fonts.base.font(with: 18)]
        
        /// placeholder color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).placeholderColor = Colors.main
        
        /// search image color
        UISearchBar.appearance().searchImageColor = Colors.main
        
        /// clear button color
        UISearchBar.appearance().clearButtonColor = Colors.main
        
        /// remove shadows (borders) but need set backgroundColor
        UISearchBar.appearance().setBackgroundImage(UIImage(color: Colors.main), for: .any, barMetrics: .default)
        /// out of textField color for shadowless style
        UISearchBar.appearance().backgroundColor = Colors.main
        
        /// textField backgroundColor. for UISearchBarStyle.prominent only
        //UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
    }
    
    func configure(tableView: UITableView) {
        tableView.sectionIndexTrackingBackgroundColor = UIColor.clear
        tableView.sectionIndexBackgroundColor = UIColor.clear
        //tableView.sectionIndexColor = UIColor.black

    }
    
//    func configureToolbar() {
//        UIToolbar.appearance().barTintColor = UINavigationBar.appearance().barTintColor
//        UIToolbar.appearance().tintColor = UINavigationBar.appearance().tintColor
//        UIToolbar.appearance().isTranslucent = UINavigationBar.appearance().isTranslucent
//    }
//    
//    func configureButton() {
//        /// don't work for font
//        UIButton.appearance().titleLabel?.font = UIFont.systemFont(ofSize: 12)
//    }
//    
//    func configureLabel() {
//        UILabel.appearance().textColor = UIColor.cyan
//        UILabel.appearance().font = UIFont.systemFont(ofSize: 12)
//    }
}
