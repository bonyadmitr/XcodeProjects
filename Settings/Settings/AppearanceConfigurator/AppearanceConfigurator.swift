//
//  AppearanceConfigurator.swift
//  Appearance
//
//  Created by Bondar Yaroslav on 31/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import WebKit

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
    
    var keyboard: UIKeyboardAppearance {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var scrollBar: UIScrollView.IndicatorStyle {
        switch self {
        case .light:
            return .default //.black
        case .dark:
            return .white
        }
    }
}


struct AppearanceTheme: Equatable {
    let saveId: String
    let name: String
    let windowTintColor: UIColor
    let backgroundColor: UIColor
    let secondaryBackgroundColor: UIColor
    let textColor: UIColor
    let secondaryTextColor: UIColor
    let barStyle: AppearanceStyle
    let navBarColor: UIColor?
    let tabBarColor: UIColor?
    let cellSelectedColor: UIColor
}

protocol AppearanceConfiguratorDelegate {
    func didApplied(theme: AppearanceTheme)
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
    
//    private lazy var window: UIWindow? = {
//        return (UIApplication.shared.delegate as? AppDelegate)?.window
//    }()
    
    /// using Large Titles
    /// https://www.youtube.com/watch?v=oFMeH02jMUc
    func setupLargeTitles(for navigationBar: UINavigationBar) {
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
        }
    }
    
    func apply(theme: AppearanceTheme) {
        /// need all windows for Floating window
        /// affects UIActivityViewController and MFMailComposeViewController buttons color
        UIApplication.shared.windows.forEach { $0.tintColor = theme.windowTintColor }
        
        /// need for translucent UINavigationBar
//        window?.backgroundColor = theme.backgroundColor
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: theme.textColor
        ]
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.barTintColor = theme.navBarColor //bar's background
        navigationBar.barStyle = theme.barStyle.tabAndNavBars
        setupLargeTitles(for: navigationBar)
//        if #available(iOS 11.0, *) {
//            UINavigationBar.appearance().prefersLargeTitles = true
//        }
        
        UITabBar.appearance().barTintColor = theme.tabBarColor
        UITabBar.appearance().barStyle = theme.barStyle.tabAndNavBars
        
//        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: theme.secondaryTextColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: theme.windowTintColor], for: .selected)
        
        /// set cellSelectedColor
        /// https://stackoverflow.com/a/32938456/5893286
        /// not working deselecting animation (need to set for every cell)
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = theme.cellSelectedColor
//        UITableViewCell.appearance().selectedBackgroundView = backgroundView
        
        UITableViewCell.appearance().backgroundColor = theme.backgroundColor
        UITableView.appearance().backgroundColor = theme.secondaryBackgroundColor
        UIScrollView.appearance().indicatorStyle = theme.barStyle.scrollBar
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = theme.secondaryTextColor
        
        let cellLabel = UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
        cellLabel.textColor = theme.textColor
        // TODO: changing appearance not working in selected cells
        //cellLabel.isOpaque = true
        //cellLabel.backgroundColor = theme.backgroundColor
        
        /// not working coorectly for dynamic font changing (large titles)
        ///cellLabel.font
        
        UITextField.appearance().keyboardAppearance = theme.barStyle.keyboard
        
        /// fixing push bug when backgroundColor = .clear (can be set to controller's view)
        WKWebView.appearance().backgroundColor = theme.secondaryBackgroundColor
        
        UIActivityIndicatorView.appearance().color = theme.textColor
        
        AboutHeader.appearance().color = theme.textColor
        
        currentTheme = theme
        delegates.invoke { $0.didApplied(theme: theme) }
        updateAppearance()
    }
    
    func applyBaseTheme() {
        UINavigationBar.appearance().isTranslucent = false
        
        /// https://stackoverflow.com/a/21007803/5893286
        /// extendedLayoutIncludesOpaqueBars = true in all controllers
        UITabBar.appearance().isTranslucent = false
    }
    
    
//    class func configurate() {
//
//        /// color of all buttons text (tintColor)
//        /// can be overriden by doneButton.tintColor = UIColor.cyan
//        /// or any other appearance()
//        UIApplication.shared.delegate?.window??.tintColor = UIColor.magenta
//
//        /// need View controller-based status bar appearance = NO in Info.plist
//        UIApplication.shared.statusBarStyle = .lightContent
//
//        configureNavigationBar()
//        configureBarButtonItem()
//        configureToolbar()
//        configureButton()
//        configureLabel()
//        configureSearchBar()
//    }
//
//    class func configureSearchBar() {
//
//        /// change the color of the text
//        //UILabel.appearanceWhenContainedInInstancesOfClasses([UITextField.self]).textColor = UIColor.whiteColor()
//
//        //        UISearchBar.appearance().searchBarStyle = UISearchBarStyle.minimal
//        //        UISearchBar.appearance().scopeButtonTitles = nil
//
//        /// cursor, buttons and others subviews color
//        UISearchBar.appearance().tintColor = UIColor.yellow
//
//        /// out of textField color
//        UISearchBar.appearance().barTintColor = UIColor.black
//
//        /// cursor only color
//        //        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.red
//
//        /// textField backgroundColor. for UISearchBarStyle.prominent only
//        //        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.blue
//
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).layer.backgroundColor = UIColor.blue.cgColor
//
//
//        /// text color
//        //        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.blue
//        // UISearchBar.appearance().textColor = UIColor.turquoise
//
//        /// placeholder color
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).placeholderColor = UIColor.black
//
//        /// search image color
//        //        UISearchBar.appearance().searchImageColor = UIColor.turquoise
//
//        /// clear button color
//        //        UISearchBar.appearance().clearButtonColor = UIColor.turquoise
//
//        UISearchBar.appearance().isRoundTextField = true
//    }
//
//    class func configureNavigationBar() {
//
//        /// don't work if View controller-based status bar appearance = NO in Info.plist
//        /// can be edited by:
//        /// override func viewDidLoad() {
//        ///     navigationController?.navigationBar.barStyle = .default
//        /// }
//        /// but it will change status bar color for all controller in that navigationController
//        UINavigationBar.appearance().barStyle = .black
//
//        /// back button
////        UINavigationBar.appearance().backIndicatorImage
////        UINavigationBar.appearance().backIndicatorTransitionMaskImage
//
//        /// colors
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().barTintColor = Colors.main //bar's background
//        UINavigationBar.appearance().tintColor = Colors.text1 //bar's buttons
//        UINavigationBar.appearance().titleTextAttributes = [
//            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
//            NSAttributedStringKey.foregroundColor: Colors.text1
//        ]
////        NSForegroundColorAttributeName
////
////        /// shadow line off.
////        /// need: UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//    }
//
//    class func configureBarButtonItem() {
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.green
//
//        /// don't work for UIBarButtonItem in navigation bar
//        /// need UINavigationController and it's subclass
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [ViewController.self]).tintColor = UIColor.orange
//    }
//
//    class func configureToolbar() {
//        UIToolbar.appearance().barTintColor = UINavigationBar.appearance().barTintColor
//        UIToolbar.appearance().tintColor = UINavigationBar.appearance().tintColor
//        UIToolbar.appearance().isTranslucent = false
//    }
//
//    class func configureButton() {
//        /// don't work for font
//        UIButton.appearance().titleLabel?.font = UIFont.systemFont(ofSize: 12)
//    }
//
//    class func configureLabel() {
//        UILabel.appearance().textColor = UIColor.cyan
//        UILabel.appearance().font = UIFont.systemFont(ofSize: 12)
//    }
    
    private func updateAppearance() {
        for window in UIApplication.shared.windows {
            window.subviews.forEach {
                $0.removeFromSuperview()
                window.addSubview($0)
            }
        }
    }
}

extension AppearanceConfigurator {
    private static let saveThemeKey = "AppearanceConfigurator_saveThemeKey"
    
    private func saveCurrenThemet(_ theme: AppearanceTheme) {
        UserDefaults.standard.set(theme.saveId, forKey: type(of: self).saveThemeKey)
    }
    
    func loadSavedTheme() {
        let themeSaveId = UserDefaults.standard.string(forKey: AppearanceConfigurator.saveThemeKey) ?? type(of: self).themes[0].saveId
        guard let savedTheme = AppearanceConfigurator.themes.first(where: { $0.saveId == themeSaveId }) else {
            /// will be drop here at first launch
            //assertionFailure()
            return
        }
        apply(theme: savedTheme)
    }
    
    func applyAndSaveCurrent(theme: AppearanceTheme) {
        apply(theme: theme)
        saveCurrenThemet(theme)
    }
}

extension AppearanceConfigurator {
    
    static var themes = [AppearanceTheme(saveId: "0",
                                         name: L10n.themeNameDefault,
                                         windowTintColor: UIColor.defaultBlue,
                                         backgroundColor: UIColor.white,
                                         secondaryBackgroundColor: Colors.tableViewBackground,
                                         textColor: UIColor.black,
                                         secondaryTextColor: UIColor.lightGray,
                                         barStyle: .light,
                                         navBarColor: nil,
                                         tabBarColor: nil,
                                         cellSelectedColor: UIColor.lightGray),
                         AppearanceTheme(saveId: "1",
                                         name: L10n.themeNameDefaultBlack,
                                         windowTintColor: UIColor.black,
                                         backgroundColor: UIColor.white,
                                         secondaryBackgroundColor: Colors.tableViewBackground,
                                         textColor: UIColor.black,
                                         secondaryTextColor: UIColor.lightGray,
                                         barStyle: .light,
                                         navBarColor: nil,
                                         tabBarColor: nil,
                                         cellSelectedColor: UIColor.lightGray),
                         AppearanceTheme(saveId: "2",
                                         name: L10n.themeNameDark,
                                         windowTintColor: UIColor.cyan,
                                         backgroundColor: UIColor.black,
                                         secondaryBackgroundColor: #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 1),
                                         textColor: UIColor.white,
                                         secondaryTextColor: UIColor.lightGray,
                                         barStyle: .dark,
                                         navBarColor: nil,
                                         tabBarColor: nil,
                                         cellSelectedColor: UIColor.cyan),
                         AppearanceTheme(saveId: "3",
                                         name: L10n.themeNameDarkNegative,
                                         windowTintColor: UIColor.cyan,
                                         backgroundColor: #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 1),
                                         secondaryBackgroundColor: UIColor.black,
                                         textColor: UIColor.white,
                                         secondaryTextColor: UIColor.lightGray,
                                         barStyle: .dark,
                                         navBarColor: nil,
                                         tabBarColor: nil,
                                         cellSelectedColor: UIColor.cyan)]
}
