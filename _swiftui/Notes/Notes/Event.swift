//
//  Event.swift
//  Notes
//
//  Created by Yaroslav Bondar on 11.12.2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import SwiftUI
import CoreData

extension Event {
    static func create(in managedObjectContext: NSManagedObjectContext) -> Self {
        let newEvent = self.init(context: managedObjectContext)
        newEvent.timestamp = Date()
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return newEvent
    }   
}

extension Collection where Element == Event, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0]) }       
 
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
