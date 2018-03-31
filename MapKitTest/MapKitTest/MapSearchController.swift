//
//  MapSearchController.swift
//  MapKitTest
//
//  Created by Bondar Yaroslav on 28/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class MapSearchController: UISearchController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setup()
    }
    
    func setup() {
        hidesNavigationBarDuringPresentation = false
        //        searchController.searchBar.sizeToFit()
        //        searchController.dimsBackgroundDuringPresentation = false
        
        //        searchController.searchBar.searchBarStyle = .minimal
        
        //        searchController.searchBar.barTintColor = UIColor.blue
        
        
    }
}
