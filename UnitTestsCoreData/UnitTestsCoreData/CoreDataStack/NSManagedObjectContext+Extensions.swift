//
//  NSManagedObjectContext+Extensions.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 30/07/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

typealias CoreDataSaveStatusHandler = (CoreDataSaveStatus) -> Void

enum CoreDataSaveStatus {
    case saved
    case hasNoChanges
    case rolledBack(Error)
}

extension NSManagedObjectContext {
    
    func saveAsync(completion: CoreDataSaveStatusHandler? = nil) {
        guard hasChanges else {
            completion?(.hasNoChanges)
            return
        }
        /// weak ???
        perform {
            do {
                try self.save()
                completion?(.saved)
            } catch {
                assertionFailure(error.localizedDescription)
                self.rollback()
                completion?(.rolledBack(error))
            }
        }
    }
    
    func saveSync(completion: CoreDataSaveStatusHandler? = nil) {
        guard hasChanges else {
            completion?(.hasNoChanges)
            return
        }
        /// weak ???
        performAndWait {
            do {
                try self.save()
                completion?(.saved)
            } catch {
                assertionFailure(error.localizedDescription)
                self.rollback()
                completion?(.rolledBack(error))
            }
        }
    }
    
    /// saveAsync + saveSync method with if statement
    func save(async: Bool, completion: CoreDataSaveStatusHandler? = nil) {
        guard hasChanges else {
            completion?(.hasNoChanges)
            return
        }
        /// weak ???
        let performBlock = {
            do {
                try self.save()
                completion?(.saved)
            } catch {
                assertionFailure(error.localizedDescription)
                self.rollback()
                completion?(.rolledBack(error))
            }
        }
        
        if async {
            perform(performBlock)
        } else {
            performAndWait(performBlock)
        }
    }
    
    // TODO: need to test without NSManagedObjectContextDidSave notification
//    func saveAsyncWithParantMerge(completion: CoreDataSaveStatusHandler? = nil) {
//        saveAsync { [weak self] status in
//            switch status {
//            case .saved:
//                let mainContext = CoreDataStack.shared.mainContext
//                if self != mainContext, self?.parent == mainContext {
//                    mainContext.saveAsync(completion: completion)
//                } else {
//                    completion?(.saved)
//                }
//            default:
//                completion?(status)
//            }
//        }
//    }
    
    @discardableResult
    func saveSyncUnsafe() -> CoreDataSaveStatus {
        if hasChanges {
            do {
                try save()
                return .saved
            } catch {
                assertionFailure(error.localizedDescription)
                rollback()
                return .rolledBack(error)
            }
        }
        return .hasNoChanges
    }
    
    
    func delete<T: NSManagedObject>(_ type: T.Type) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        if #available(iOS 10.0, *) {
            fetchRequest = type.fetchRequest()
        } else {
            fetchRequest = NSFetchRequest(entityName: type.className())
        }
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try execute(deleteRequest)
            try save()
        } catch {
            assertionFailure(error.localizedDescription)
            print ("There was an error")
        }
    }
    
    func deleteRequest<T: NSManagedObject>(for type: T.Type) -> NSBatchDeleteRequest {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        if #available(iOS 10.0, *) {
            fetchRequest = type.fetchRequest()
        } else {
            fetchRequest = NSFetchRequest(entityName: type.className())
        }
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
    
    func deleteAll(completion: CoreDataSaveStatusHandler? = nil) {
        assertionFailure("NSManagedObject")
        perform { [weak self] in
            do {
                try [NSManagedObject.self]
                    .compactMap { self?.deleteRequest(for: $0) }
                    .forEach { try self?.execute($0) }
                try self?.save()
                completion?(.saved)
            } catch {
                assertionFailure(error.localizedDescription)
                self?.rollback()
                completion?(.rolledBack(error))
            }
        }
    }
}

extension NSObject {
    static func className() -> String {
        return String(describing: self.self)
    }
}
