//
//  NSManagedObject+Extensions.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 30/07/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

typealias ManagedObjectDeleteStatusHandler = (ManagedObjectDeleteStatus) -> Void

enum ManagedObjectDeleteStatus {
    case deleted
    case thereIsNoContext
    case error(Error)
}

extension NSManagedObject {
    convenience init(managedObjectContext moc: NSManagedObjectContext) {
        let className = String(describing: type(of: self))
        if let entityDescription = NSEntityDescription.entity(forEntityName: className, in: moc) {
            self.init(entity: entityDescription, insertInto: moc)
        } else {
            assertionFailure("Unable to create entity description with \(className)")
            self.init()
        }
        
        /// don't use iOS 10 "init(context:".
        /// there will be warnings from CoreData with "entity is unable to disambiguate"
        /// https://github.com/drewmccormack/ensembles/issues/275
        //if #available(iOS 10.0, macOS 10.12, *) {
        //    self.init(context: moc)
        //} else {
        //    let className = String(describing: type(of: self))
        //    if let entityDescription = NSEntityDescription.entity(forEntityName: className, in: moc) {
        //        self.init(entity: entityDescription, insertInto: moc)
        //    } else {
        //        assertionFailure("Unable to create entity description with \(className)")
        //        self.init()
        //    }
        //}
    }
    
    /// delete NSManagedObject on same context that was fetched
    func delete(completion: ManagedObjectDeleteStatusHandler? = nil) {
        guard let context = managedObjectContext else {
            assertionFailure()
            completion?(.thereIsNoContext)
            return
        }
        /// weak?
        context.perform {
            context.delete(self)
            do {
                try context.save()
                completion?(.deleted)
            } catch {
                assertionFailure(error.localizedDescription)
                completion?(.error(error))
            }
            
        }
    }
}
