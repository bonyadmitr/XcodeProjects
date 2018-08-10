//
//  SearchResultsViewController.swift
//  tvOStest
//
//  Created by Bondar Yaroslav on 8/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SearchResultsViewController: UIViewController {
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        title = "Search"
//        tabBarItem.title = "Search"
//        if let tabBarItem = tabBarItem {
//            
//        } else {
//            tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
