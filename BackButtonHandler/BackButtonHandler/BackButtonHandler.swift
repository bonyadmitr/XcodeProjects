//
//  BackButtonHandler.swift
//  BackButtonHandler
//
//  Created by Bondar Yaroslav on 2/16/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

typealias BoolHandler = (Bool) -> Void

protocol BackButtonHandler {
    func shouldPopOnBackButton(_ handler: @escaping BoolHandler)
}

extension BackButtonHandler where Self: UIViewController {
    
    func viewWillAppearBackButtonHandler() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        previousNavigationVC().navigationItem.backBarButtonItem = NoMenuBackBarButtonItem.shared
    }
    
    func viewWillDisappearBackButtonHandler() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.topViewController?.navigationItem.backBarButtonItem = nil
    }
    
//    private func previousVC() -> UIViewController {
//        guard let navigationController = navigationController, navigationController.viewControllers.count >= 2 else {
//            assertionFailure()
//            return UIViewController()
//        }
//        navigationController.interactivePopGestureRecognizer?.isEnabled = false
//        return navigationController.viewControllers[navigationController.viewControllers.count - 2]
//    }
    
}

extension UIViewController {
    func previousNavigationVC() -> UIViewController {
        guard let navigationController = navigationController, navigationController.viewControllers.count >= 2 else {
            assertionFailure()
            return UIViewController()
        }
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        return navigationController.viewControllers[navigationController.viewControllers.count - 2]
    }
    
    func previousNavigationVCTitle() -> String? {
        let vc = previousNavigationVC()
        return vc.navigationItem.backBarButtonItem?.title ?? vc.title ?? vc.navigationItem.title
    }
}

//extension UINavigationController: UINavigationBarDelegate  {
//    /// NOTE: this funcion will be called for all pop actions
//    /// https://stackoverflow.com/a/43585267
//    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
//
//        /// or maybe need to check: viewControllers.count > 1
//        if viewControllers.count < navigationBar.items?.count ?? 0 {
//            return true
//        }
//
//        guard let vc = topViewController as? BackButtonHandler else {
//            popVC()
//            return true
//        }
//
//        vc.shouldPopOnBackButton { [weak self] isPopBack in
//            if isPopBack {
//                self?.popVC()
//            } else {
//                self?.animateNavigationBar()
//            }
//        }
//
//        return false
//    }
//    
//    private func animateNavigationBar() {
//        for subView in navigationBar.subviews {
//            if 0 < subView.alpha && subView.alpha < 1 {
//                UIView.animate(withDuration: 0.25) {
//                    subView.alpha = 1
//                }
//            }
//        }
//    }
//    
//    private func popVC() {
//        DispatchQueue.main.async {
//            _ = self.popViewController(animated: true)
//        }
//    }
//}

final class BackButtonHandlerNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.delegate = self
    }
    
}

/// inspired https://stackoverflow.com/a/43585267
/// for iOS 15 needs UINavigationController subclass
extension BackButtonHandlerNavigationController: UINavigationBarDelegate  {
    
    /// not working for long press menu. use NoMenuBackBarButtonItem
    /// NOTE: this funcion will be called for all pop actions
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        /// or maybe need to check: viewControllers.count > 1
        if viewControllers.count < navigationBar.items?.count ?? 0 {
            return true
        }
        
        guard let vc = topViewController as? BackButtonHandler else {
            //popVC() /// used for `extension UINavigationController: UINavigationBarDelegate`, but not for subclass
            return true
        }
        
        vc.shouldPopOnBackButton { [weak self] isPopBack in
            if isPopBack {
                self?.popVC()
            } else {
                self?.animateNavigationBar()
            }
        }
        
        return false
    }
    
    // TODO: check needs
    private func animateNavigationBar() {
        for subView in navigationBar.subviews {
            if 0 < subView.alpha && subView.alpha < 1 {
                UIView.animate(withDuration: 0.25) {
                    subView.alpha = 1
                }
            }
        }
    }
    
    private func popVC() {
        DispatchQueue.main.async {
            _ = self.popViewController(animated: true)
        }
    }
}

/// inspired https://stackoverflow.com/a/64386528/5893286
final class NoMenuBackBarButtonItem: UIBarButtonItem {
    
    /// target-action is not working to handle back button action
    static let shared = NoMenuBackBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: nil, action: nil)
    
    @available(iOS 14.0, *)
    override var menu: UIMenu? {
        get { super.menu }
        set { /* Don't set the menu here to prevent navigation menu */ }
    }
}
