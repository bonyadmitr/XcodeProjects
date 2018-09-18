//
//  EventDB+New.swift
//  FetchedResultsController
//
//  Created by Bondar Yaroslav on 9/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData
import UIKit

extension EventDB {
    static func createAndSaveNewOne() {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest = EventDB.fetchRequest()
            let numberOfEvents = (try? context.count(for: fetchRequest)) ?? 0
            
            let event = EventDB(managedObjectContext: context)
            event.title = "Event \(numberOfEvents + 1)"
            event.date = Date().withoutSeconds
            context.saveAsync()
        }
    }
    
    static func fetchedResultsController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<EventDB> {
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
        frController.delegate = delegate
        return frController
    }
}
