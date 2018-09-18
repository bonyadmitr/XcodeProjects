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
        
        func randomString(length: Int) -> String {
            
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let len = UInt32(letters.length)
            
            var randomString = ""
            
            for _ in 0 ..< length {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            
            return randomString
        }
        
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest = EventDB.fetchRequest()
            let numberOfEvents = (try? context.count(for: fetchRequest)) ?? 0
            
            let event = EventDB(managedObjectContext: context)
            event.title = "\(randomString(length: 5)) \(numberOfEvents + 1)" 
            event.date = Date().withoutSeconds
            context.saveAsync()
        }
    }
    
    static func fetchedResultsController() -> NSFetchedResultsController<EventDB> {
        let fetchRequest: NSFetchRequest = EventDB.fetchRequest()
        //fetchRequest.fetchLimit = 100
        let sortDescriptor1 = NSSortDescriptor(key: #keyPath(EventDB.date), ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: #keyPath(EventDB.title), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            fetchRequest.fetchBatchSize = 50
        } else {
            fetchRequest.fetchBatchSize = 20
        }
        
        //fetchRequest.relationshipKeyPathsForPrefetching = [#keyPath(PostDB.id)]
        let context = CoreDataStack.shared.mainContext
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(EventDB.date), cacheName: nil)
    }
}
