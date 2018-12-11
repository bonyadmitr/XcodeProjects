//
//  CoreDataStack.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 7/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

extension CoreDataStack {
    static let shared = CoreDataStack(storeType: .sqlite, modelName: "UnitTestsCoreData")
    
    /// working ONLY with NSSQLiteStoreType
    /// https://stackoverflow.com/a/50154532/5893286
    func deleteAll(completion: CoreDataSaveStatusHandler? = nil) {
        
        
        switch storeType {
        case .sqlite:
            
            /// sync
            let context = newBackgroundContext()
            //        let context = viewContext
            do {
                try [DBEvent.self]
                    .compactMap { batchDeleteRequest(for: $0) }
                    .forEach { try context.execute($0) }
                try context.save()
                completion?(.saved)
            } catch {
                assertionFailure(error.localizedDescription)
                context.rollback()
                completion?(.rolledBack(error))
            }
            
            /// async
            //        container.performBackgroundTask { context in
            //            do {
            //                try [DBEvent.self]
            //                    .compactMap { context.deleteRequest(for: $0) }
            //                    .forEach { try context.execute($0) }
            //                try context.save()
            //                completion?(.saved)
            //            } catch {
            //                assertionFailure(error.localizedDescription)
            //                context.rollback()
            //                completion?(.rolledBack(error))
            //            }
            //        }
            
            /// async
            //        let context = newBackgroundContext()
            //        context.perform {
            //            do {
            //                try [DBEvent.self]
            //                    .compactMap { context.deleteRequest(for: $0) }
            //                    .forEach { try context.execute($0) }
            //                try context.save()
            //                completion?(.saved)
            //            } catch {
            //                assertionFailure(error.localizedDescription)
            //                context.rollback()
            //                completion?(.rolledBack(error))
            //            }
        //        }
            
            
        case .memory:
            let context = newBackgroundContext()
            //context.perform {}
            do {
                try [DBEvent.self]
                    .map { deleteRequest(for: $0) }
                    .forEach { fetchRequest in
                        let models = try context.fetch(fetchRequest)
                        models.forEach { context.delete($0) }
                    }
                try context.save()
                completion?(.saved)
            } catch {
                assertionFailure(error.localizedDescription)
                context.rollback()
                completion?(.rolledBack(error))
            }
        }

    }
    
    private func deleteRequest<T: NSManagedObject>(for type: T.Type) -> NSFetchRequest<T> {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: type.className())
        fetchRequest.includesPropertyValues = false
        //fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
    /// work only with SQLite persistent store
    /// https://developer.apple.com/library/archive/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html
    func batchDeleteRequest<T: NSManagedObject>(for type: T.Type) -> NSBatchDeleteRequest {
        /// this will work only with NSManagedObject(context: that we removed
        //        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        //        if #available(iOS 10.0, *) {
        //            fetchRequest = type.fetchRequest()
        //        } else {
        //            fetchRequest = NSFetchRequest(entityName: type.className())
        //        }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: type.className())
        fetchRequest.includesPropertyValues = false
        fetchRequest.returnsObjectsAsFaults = false
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
}

final class CoreDataStack {
    
    let storeType: PersistentStoreType
//    private let modelName: String
    private let container: StoreContainer
    
    /// oldAPI is iOS 9 api
    init(storeType: PersistentStoreType, modelName: String, oldAPI: Bool = false) {
        self.storeType = storeType
//        self.modelName = modelName
        
        if oldAPI {
            container = type(of: self).basicPersistentContainer(storeType: storeType, modelName: modelName)
        } else {
            if #available(iOS 10.0, *) {
                container = type(of: self).persistentContainer(storeType: storeType, modelName: modelName)
            } else {
                container = type(of: self).basicPersistentContainer(storeType: storeType, modelName: modelName)
            }
        }
        
        container.automaticallyMergesChangesFromParent()
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
    
    func clearAll() {
        container.clearAll()
    }
}

extension CoreDataStack {
    // MARK: - static get
    
    @available(iOS 10.0, *)
    private static func persistentContainer(storeType: PersistentStoreType, modelName: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: modelName)
        
        switch storeType {
        case .memory:
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            // TODO: - need shouldAddStoreAsynchronously? -
            //description.shouldAddStoreAsynchronously = true
            container.persistentStoreDescriptions = [description]
        case .sqlite:
            break
        }
        
        container.loadPersistentStores { storeDescription, error in
            //print("CoreData: Inited \(storeDescription)")
            print("- CoreData: Inited")
            if let error = error {
                assertionFailure(error.localizedDescription)
                print("CoreData: Unresolved error \(error)")
                return
            }
        }
        return container
    }
    
    private static func basicPersistentContainer(storeType: PersistentStoreType, modelName: String) -> PersistentContainer {
        let container = PersistentContainer(name: modelName)
        do {
            try container.loadPersistentStore(type: storeType)
        } catch {
            assertionFailure(error.localizedDescription)
            print(error.localizedDescription)
        }
        return container
    }
}
