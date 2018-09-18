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
    
    lazy var fetchedResultsController: NSFetchedResultsController<EventDB> = {
        let fetchRequest: NSFetchRequest = EventDB.fetchRequest()
        let sortDescriptor2 = NSSortDescriptor(key: #keyPath(EventDB.date), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor2]
        
        // TODO: device isIpad
        if UI_USER_INTERFACE_IDIOM() == .pad {
            fetchRequest.fetchBatchSize = 50
        } else {
            fetchRequest.fetchBatchSize = 20
        }
        
        //fetchRequest.relationshipKeyPathsForPrefetching = [#keyPath(PostDB.id)]
        let context = CoreDataStack.shared.mainContext
        let frController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frController.delegate = self
        return frController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    @IBAction private func addEvent(_ sender: UIBarButtonItem) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest = EventDB.fetchRequest()
            let numberOfEvents = (try? context.count(for: fetchRequest)) ?? 0
            
            let event = EventDB(managedObjectContext: context)
            event.title = "Event \(numberOfEvents + 1)"
            event.date = Date()
            context.saveAsync()
        }
    }
}

extension TableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
    }
}

extension TableController: UITableViewDelegate {
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
}

extension TableController: NSFetchedResultsControllerDelegate {
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
