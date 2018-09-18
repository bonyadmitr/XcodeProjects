//
//  EventDB+New.swift
//  FetchedResultsController
//
//  Created by Bondar Yaroslav on 9/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

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
}
