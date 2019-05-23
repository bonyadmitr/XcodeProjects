//
//  TableController.swift
//  FetchedResultsController
//
//  Created by Bondar Yaroslav on 9/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreData

// TODO: test frc updated for search and sorting
// https://stackoverflow.com/a/3696104

// TODO: UISearchController with fetchedResultsController with cacheName
// do we need to delete cache in this case?
// TODO: animated search
// https://gist.github.com/stephanecopin/fbeca87e2f66e522ffd6b197955d5f49
class TableController: UIViewController {
    
    private enum SortOrder: Int, CaseIterable {
        case dateNameUp = 0
        case dateNameDown
        
        var title: String {
            switch self {
            case .dateNameUp:
                return "Date/Name up"
            case .dateNameDown:
                return "Date/Name down"
            }
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            //tableView.keyboardDismissMode = .onDrag
        }
    }
    
    /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html
    /// The sectionNameKeyPath property must also be an NSSortDescriptor instance.
    /// The NSSortDescriptor must be the first descriptor in the array passed to the fetch request.
    private lazy var fetchedResultsController = EventDB.fetchedResultsController()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        fetchedResultsController.delegate = self
        performFetch()
    }
    
    private func performFetch() {
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    /// https://developer.apple.com/documentation/uikit/view_controllers/displaying_searchable_content_by_using_a_search_controller
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController
            
            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }
        
        //searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // The default is true.
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
         This means that the presentation moves up the view controller hierarchy until it finds the root
         view controller or one that defines a presentation context.
         */
        
        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = SortOrder.allCases.map { $0.title }
    }
    
    @IBAction private func addEvent(_ sender: UIBarButtonItem) {
        EventDB.createAndSaveNewOne()
    }
}

extension TableController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
    }
}

extension TableController: UITableViewDelegate {
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return fetchedResultsController.sectionIndexTitles
//    }
//
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EventCell else {
            return
        }
        let event = fetchedResultsController.object(at: indexPath)
        cell.fill(with: event)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        /// weak?
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
            let event = self?.fetchedResultsController.object(at: indexPath)
            event?.delete()
        }
        return [action]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
}

extension TableController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .update, .move:
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        }
    }
}

extension TableController: UISearchBarDelegate {
    /// default for iOS 12
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        guard let sortOrder = SortOrder(rawValue: selectedScope) else {
            assertionFailure()
            return
        }
        
        let sortDescriptors: [NSSortDescriptor]
        
        switch sortOrder {
        case .dateNameUp:
            // TODO: reuse with fetchedResultsController
            let sortDescriptor1 = NSSortDescriptor(key: #keyPath(EventDB.date), ascending: false)
            let sortDescriptor2 = NSSortDescriptor(key: #keyPath(EventDB.title), ascending: false)
            sortDescriptors = [sortDescriptor1, sortDescriptor2]

        case .dateNameDown:
            let sortDescriptor1 = NSSortDescriptor(key: #keyPath(EventDB.date), ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: #keyPath(EventDB.title), ascending: true)
            sortDescriptors = [sortDescriptor1, sortDescriptor2]
        }
        
        fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
        performFetch()
    }
}

//extension TableController: UISearchControllerDelegate {}

extension TableController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            assertionFailure()
            return
        }
        
        let predicate: NSPredicate?
        if searchText.isEmpty {
            /// pass reference to default predicate in fetchedResultsController.fetchRequest
            predicate = nil
        } else {
            predicate = NSPredicate(format: "(\(#keyPath(EventDB.title)) contains[cd] %@)", searchText)
            //predicate = NSPredicate(format: "(\(#keyPath(EventDB.title)) contains[cd] %@) || (\(#keyPath(EventDB.date)) contains[cd] %@)", searchText, searchText)
        }
        
        fetchedResultsController.fetchRequest.predicate = predicate
        performFetch()
    }
}
