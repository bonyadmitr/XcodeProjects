//
//  ViewController.swift
//  tvOStest
//
//  Created by Bondar Yaroslav on 8/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem = UITabBarItem(title: "", image: nil, selectedImage: nil)
    }
}

/// protocol UIFocusEnvironment
extension ViewController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [testButton]
    }
}


final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchContainerDisplay()
        
        // Sets the default color of the icon of the selected UITabBarItem and Title
//        UIBarButtonItem.appearance().tintColor = UIColor.black
//        UITabBar.appearance().tintColor = UIColor.black
        // Sets the default color of the background of the UITabBar
//        UITabBar.appearance().barTintColor = UIColor.black
        
//        UITabBar.appearance().isTranslucent = false
        
        if let tbItems = tabBar.items {
            
            let tabBarItem1: UITabBarItem = tbItems[0]
            let tabBarItem2: UITabBarItem = tbItems[1]
            let tabBarItem3: UITabBarItem = tbItems[2]
            tabBarItem1.title = "Home"
            tabBarItem2.title = "Programs"
            tabBarItem3.title = "Search"
        }
        
//        if let tabBarItems = tabBar.items{
//            for item in tabBarItems as [UITabBarItem] {
//                //Preserves white Color on selected
//                tabBar.tintColor = UIColor.white
//                
//                item.setTitleTextAttributes([.foregroundColor: UIColor.white], for:UIControlState())
//                item.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .disabled)
//                item.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .selected)
//            }
//        }
    }
    
    func searchContainerDisplay(){
        
        guard let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController else {
            return
        }
        
        let searchController = SearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        
//        searchController.hidesNavigationBarDuringPresentation = false
//        if #available(tvOS 9.1, *) {
//            searchController.obscuresBackgroundDuringPresentation = true
//        }
        
//        searchController.searchBar.placeholder = NSLocalizedString("Search Title", comment: "")
//        searchController.searchBar.tintColor = UIColor.black
//        searchController.searchBar.barTintColor = UIColor.black
//        searchController.searchBar.searchBarStyle = .minimal
//        searchController.searchBar.keyboardAppearance = .dark
        
        let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
        let navController = UINavigationController(rootViewController: searchContainerViewController)
//        navController.view.backgroundColor = UIColor.black
        
        if var tbViewController = viewControllers {
            tbViewController.append(navController)
            viewControllers = tbViewController
        }
        
    }

}
