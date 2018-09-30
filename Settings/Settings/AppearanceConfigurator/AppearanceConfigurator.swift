//
//  AppearanceConfigurator.swift
//  Appearance
//
//  Created by Bondar Yaroslav on 31/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

struct Colors {
    private init() {}
    
    static let main = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    static let text1 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    static let tableViewBackground = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
}

enum AppearanceStyle {
    case light
    case dark
}
extension AppearanceStyle {
    var tabAndNavBars: UIBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .black
        }
    }
    var statusBar: UIStatusBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .lightContent
        }
    }
}


struct AppearanceTheme: Equatable {
    let name: String
    let windowTintColor: UIColor
    let backgroundColor: UIColor
    let textColor: UIColor
    let tableViewBackgroundColor: UIColor
    let barStyle: AppearanceStyle
}

protocol AppearanceConfiguratorDelegate {
    func didApplied(theme: AppearanceTheme)
}

extension AppearanceConfigurator {
    static var themes = [AppearanceTheme(name: "Black and White",
                                         windowTintColor: UIColor.magenta,
                                         backgroundColor: UIColor.white,
                                         textColor: UIColor.black,
                                         tableViewBackgroundColor: Colors.tableViewBackground,
                                         barStyle: .light),
                         AppearanceTheme(name: "Dark",
                                         windowTintColor: UIColor.blue,
                                         backgroundColor: UIColor.black,
                                         textColor: UIColor.white,
                                         tableViewBackgroundColor: UIColor.black,
                                         barStyle: .dark)]
}

///appearance(whenContainedInInstancesOf: or appearanceForTraitCollection:whenContainedIn
// TODO: appearance(for: UITraitCollection)
/// I didn't find a way to localize standart buttons like "done", "cancel" without app restrart
// sp don't use them. Simply write title "done" and addd translation to Localizable.strings
final class AppearanceConfigurator: MulticastHandler {
    
    internal var delegates = MulticastDelegate<AppearanceConfiguratorDelegate>()
    
    static let shared = AppearanceConfigurator()
    
    func configureLocalizedAppearance() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).lzTitle = "cancel"
    }
    
    var currentTheme: AppearanceTheme = AppearanceConfigurator.themes[0]
    
    init() {
        applyBaseTheme()
    }
    
    func apply(theme: AppearanceTheme) {
        UIApplication.shared.statusBarStyle = theme.barStyle.statusBar
        // TODO: create window property
        UIApplication.shared.delegate?.window??.tintColor = theme.textColor//theme.windowTintColor
        UIApplication.shared.delegate?.window??.backgroundColor = theme.backgroundColor
        
        let textAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: theme.textColor
        ]
        
        UINavigationBar.appearance().titleTextAttributes = textAttributes
//        UINavigationBar.appearance().barTintColor = theme.backgroundColor //bar's background
        UINavigationBar.appearance().barStyle = theme.barStyle.tabAndNavBars
        
//        UITabBar.appearance().barTintColor = theme.backgroundColor
        UITabBar.appearance().barStyle = theme.barStyle.tabAndNavBars
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(textAttributes, for: .selected)
        
        UITableViewCell.appearance().backgroundColor = theme.backgroundColor
        UITableView.appearance().backgroundColor = theme.tableViewBackgroundColor
        
//        UILabel.appearance().textColor = theme.textColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = theme.textColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = theme.textColor
        
        currentTheme = theme
        updateAppearance()
        delegates.invoke { $0.didApplied(theme: theme) }
    }
    
    func applyBaseTheme() {
        UINavigationBar.appearance().isTranslucent = true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    class func configurate() {
        
        /// color of all buttons text (tintColor)
        /// can be overriden by doneButton.tintColor = UIColor.cyan
        /// or any other appearance()
        UIApplication.shared.delegate?.window??.tintColor = UIColor.magenta
        
        /// need View controller-based status bar appearance = NO in Info.plist
        UIApplication.shared.statusBarStyle = .lightContent
        
        configureNavigationBar()
        configureBarButtonItem()
        configureToolbar()
        configureButton()
        configureLabel()
        configureSearchBar()
    }
    
    class func configureSearchBar() {
        
        /// change the color of the text
        //UILabel.appearanceWhenContainedInInstancesOfClasses([UITextField.self]).textColor = UIColor.whiteColor()
        
        //        UISearchBar.appearance().searchBarStyle = UISearchBarStyle.minimal
        //        UISearchBar.appearance().scopeButtonTitles = nil
        
        /// cursor, buttons and others subviews color
        UISearchBar.appearance().tintColor = UIColor.yellow
        
        /// out of textField color
        UISearchBar.appearance().barTintColor = UIColor.black
        
        /// cursor only color
        //        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.red
        
        /// textField backgroundColor. for UISearchBarStyle.prominent only
        //        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.blue
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).layer.backgroundColor = UIColor.blue.cgColor
        
        
        /// text color
        //        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.blue
        // UISearchBar.appearance().textColor = UIColor.turquoise
        
        /// placeholder color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).placeholderColor = UIColor.black
        
        /// search image color
        //        UISearchBar.appearance().searchImageColor = UIColor.turquoise
        
        /// clear button color
        //        UISearchBar.appearance().clearButtonColor = UIColor.turquoise
        
        UISearchBar.appearance().isRoundTextField = true
    }
    
    class func configureNavigationBar() {
        
        /// don't work if View controller-based status bar appearance = NO in Info.plist
        /// can be edited by:
        /// override func viewDidLoad() {
        ///     navigationController?.navigationBar.barStyle = .default
        /// }
        /// but it will change status bar color for all controller in that navigationController
        UINavigationBar.appearance().barStyle = .black
        
        /// back button
//        UINavigationBar.appearance().backIndicatorImage
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage
        
        /// colors
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = Colors.main //bar's background
        UINavigationBar.appearance().tintColor = Colors.text1 //bar's buttons
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor: Colors.text1
        ]
//        NSForegroundColorAttributeName
//
//        /// shadow line off.
//        /// need: UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    class func configureBarButtonItem() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.green
        
        /// don't work for UIBarButtonItem in navigation bar
        /// need UINavigationController and it's subclass
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [ViewController.self]).tintColor = UIColor.orange
    }
    
    class func configureToolbar() {
        UIToolbar.appearance().barTintColor = UINavigationBar.appearance().barTintColor
        UIToolbar.appearance().tintColor = UINavigationBar.appearance().tintColor
        UIToolbar.appearance().isTranslucent = false
    }
    
    class func configureButton() {
        /// don't work for font
        UIButton.appearance().titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    class func configureLabel() {
        UILabel.appearance().textColor = UIColor.cyan
        UILabel.appearance().font = UIFont.systemFont(ofSize: 12)
    }
    
    private func updateAppearance() {
        for window in UIApplication.shared.windows {
            window.subviews.forEach {
                $0.removeFromSuperview()
                window.addSubview($0)
            }
        }
    }
}
