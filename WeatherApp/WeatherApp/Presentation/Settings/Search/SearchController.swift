//
//  SearchController.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 06/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        //hidesNavigationBarDuringPresentation = true
        dimsBackgroundDuringPresentation = false
        searchBar.autoresizingMask = [.flexibleWidth]
        searchBar.sizeToFit()
    }
    
    func addSearchBar(to view: UIView) {
        if let tableView = view as? UITableView {
            tableView.tableHeaderView = searchBar
            return
        }
        searchBar.frame = view.bounds
        view.addSubview(searchBar)
    }
    
    func setup(in vc: UIViewController) {
        vc.extendedLayoutIncludesOpaqueBars = true
        vc.definesPresentationContext = true
    }
}

//        searchManager = SearchManager(controller: PlacesController())
//        searchManager.setup(in: self)
//        searchManager.addSearchBar(to: searchContainerView)
//        searchManager.searchHandler = { text in
//            return ["1", "2", text]
//        }


//class SearchManager: NSObject {
//
//    var searchController: UISearchController!
//    var vc: PlacesController!
//
//    private override init() {
//        super.init()
//    }
//
//    var searchHandler: ((String)-> [String])?
//
//    convenience init(controller: PlacesController?) {
//        self.init()
//
//        searchController = UISearchController(searchResultsController: controller)
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchResultsUpdater = self
//        //searchController.hidesNavigationBarDuringPresentation = true
//
//        searchController.searchBar.autoresizingMask = [.flexibleWidth]
//        searchController.searchBar.lzPlaceholder = "new_city"
//
//        vc = controller
//        vc.searchController = searchController
//    }
//
//    func addSearchBar(to view: UIView) {
//        if let tableView = view as? UITableView {
//            tableView.tableHeaderView = searchController.searchBar
//            return
//        }
//        searchController.searchBar.frame = view.bounds
//        view.addSubview(searchController.searchBar)
//    }
//
//    func setup(in vc: UIViewController) {
//        vc.extendedLayoutIncludesOpaqueBars = true
//        vc.definesPresentationContext = true
//    }
//}
//extension SearchManager: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text,
//            let searchHandler = self.searchHandler
//            else { return }
//        vc.dataSource = searchHandler(text)
//    }
//}
