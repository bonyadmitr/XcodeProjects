//
//  SearchResultsViewController.swift
//  tvOStest
//
//  Created by Bondar Yaroslav on 8/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SearchResultsViewController: UIViewController {
    
    
    
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


import UIKit

final class SearchController: UISearchController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        hidesNavigationBarDuringPresentation = false
//        if #available(tvOS 9.1, *) {
//            obscuresBackgroundDuringPresentation = false
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        moveSearchBarToCenter()
        
    }
}
