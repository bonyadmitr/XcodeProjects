//
//  TabBarController.swift
//  tvOStest
//
//  Created by Bondar Yaroslav on 8/10/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchContainerDisplay()
    }
    
    func searchContainerDisplay(){
        guard let navController = SearchController.resultsController() else {
            return
        }
        viewControllers?.append(navController)
    }
}
