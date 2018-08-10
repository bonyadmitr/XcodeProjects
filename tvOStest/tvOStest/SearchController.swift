//
//  SearchController.swift
//  tvOStest
//
//  Created by Bondar Yaroslav on 8/10/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SearchController: UISearchController {
    
    static func resultsController() -> UINavigationController? {
        guard let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController else {
            return nil
        }
        return searchController(with: resultsController)
    }
    
    
    static func searchController(with searchResultsController: UIViewController) -> UINavigationController {
        let searchController = SearchController(searchResultsController: searchResultsController)
        let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
        let navVC = UINavigationController(rootViewController: searchContainerViewController)
        
        /// tabBarItem will be created with vc title name
        navVC.tabBarItem = searchResultsController.tabBarItem
        
        return navVC
    }
    
    /// need for "override init(searchResultsController: UIViewController?)" bcz of crash
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// from doc: don't pass nil for tvOS
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        
        if let updater = searchResultsController as? UISearchResultsUpdating {
            searchResultsUpdater = updater
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// or 1
        //        hidesNavigationBarDuringPresentation = false
        //        if #available(tvOS 9.1, *) {
        //            obscuresBackgroundDuringPresentation = false
        //        }
        
        /// or 2. maybe must be set in tabBar
        //        searchController.hidesNavigationBarDuringPresentation = false
        //        if #available(tvOS 9.1, *) {
        //            searchController.obscuresBackgroundDuringPresentation = true
        //        }
        
        //        searchController.searchBar.placeholder = NSLocalizedString("Search Title", comment: "")
        //        searchController.searchBar.tintColor = UIColor.black
        //        searchController.searchBar.barTintColor = UIColor.black
        //        searchController.searchBar.searchBarStyle = .minimal
        //        searchController.searchBar.keyboardAppearance = .dark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //moveSearchBarToCenter()
        
    }
}
