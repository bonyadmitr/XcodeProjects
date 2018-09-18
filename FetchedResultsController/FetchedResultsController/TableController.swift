//
//  TableController.swift
//  FetchedResultsController
//
//  Created by Bondar Yaroslav on 9/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreData

class TableController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html
    /// The sectionNameKeyPath property must also be an NSSortDescriptor instance.
    /// The NSSortDescriptor must be the first descriptor in the array passed to the fetch request.
    lazy var fetchedResultsController: NSFetchedResultsController<EventDB> = {
        let fetchRequest: NSFetchRequest = EventDB.fetchRequest()
        //fetchRequest.fetchLimit = 100
        let sortDescriptor2 = NSSortDescriptor(key: #keyPath(EventDB.date), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor2]
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            fetchRequest.fetchBatchSize = 50
        } else {
            fetchRequest.fetchBatchSize = 20
        }
        
        //fetchRequest.relationshipKeyPathsForPrefetching = [#keyPath(PostDB.id)]
        let context = CoreDataStack.shared.mainContext
        let frController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(EventDB.date), cacheName: nil)
        frController.delegate = self
        return frController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
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
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }
    
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
        let indexPath = IndexPath(row: 0, section: section)
        let event = fetchedResultsController.object(at: indexPath)
        return event.date?.description
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
