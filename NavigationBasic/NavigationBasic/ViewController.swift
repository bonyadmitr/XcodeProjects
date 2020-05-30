//
//  ViewController.swift
//  NavigationBasic
//
//  Created by Bondar Yaroslav on 5/29/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


extension UITabBarController {
    
    enum Tab: Int {
        case first = 0
        case second
    }
    
    func isSelected(_ tab: Tab) -> Bool {
        selectedIndex == tab.rawValue
    }
    
    var controllers: [UIViewController] {
        return viewControllers ?? []
    }
    
    func selectFirst() {
        if controllers.count >= 1 {
            selectedIndex = 0
        }
    }
    
    func selectSecond() {
        safeSelect(at: 1)
    }
    
    func select(_ tab: Tab) {
        safeSelect(at: tab.rawValue)
    }
    
    private func safeSelect(at index: Int) {
        if controllers.count >= index + 1 {
            selectedIndex = index
        }
        
        /// more 5 https://stackoverflow.com/a/5413606/5893286
        /// if the index maps to a tab within the More view controller (should you have more than five tabs), this will not work. In that case, use -setSelectedViewController
        //if controllers.count >= index {
        //    selectedViewController = controllers[index - 1]
        //}
    }
    
}

extension UINavigationController {
    
    /// source https://stackoverflow.com/a/25230169/5893286
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool,
                            completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func replaceTopViewController(_ viewController: UIViewController, animated: Bool) {
        var currentStack = viewControllers
        if currentStack.isEmpty {
            pushViewController(viewController, animated: animated)
        } else {
            currentStack[currentStack.count - 1] = viewController
            setViewControllers(currentStack, animated: animated)
        }
    }
    
}
