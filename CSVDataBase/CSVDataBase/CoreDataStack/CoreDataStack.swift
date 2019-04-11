//
//  CoreDataStack.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 7/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

extension CoreDataStack {
    static let shared = CoreDataStack(storeType: .sqlite, modelName: "LifeBox-new")
    
    /// working ONLY with NSSQLiteStoreType
    /// https://stackoverflow.com/a/50154532/5893286
    func deleteAll(completion: CoreDataSaveStatusHandler? = nil) {
        
        
        switch storeType {
        case .sqlite:
            
            /// sync
            let context = newBackgroundContext()
            //let context = viewContext
            
            do {
                let objectIDs = try container.persistentStoreCoordinator.managedObjectModel.entities
                    .compactMap { batchDeleteRequest(for: $0) }
                    .compactMap { try context.execute($0) as? NSBatchDeleteResult }
                    .compactMap { $0.result as? [NSManagedObjectID] }
                    .flatMap { $0 }
                
                //                let objectIDs = try [DBEvent.self]
                //                    .compactMap { batchDeleteRequest(for: $0) }
                //                    .compactMap { try context.execute($0) as? NSBatchDeleteResult }
                //                    .compactMap { $0.result as? [NSManagedObjectID] }
                //                    .flatMap { $0 }
                
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context.parent ?? viewContext])
                completion?(.saved)
                
                
                //                try [DBEvent.self]
                //                    .compactMap { batchDeleteRequest(for: $0) }
                //                    .forEach { try context.execute($0) }
                //                try context.save()
                //                completion?(.saved)
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
                /// very long operation: 10 seconds for 10_000 objects
                
                try [PHItemDB.self]
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
        ///only fetch the managedObjectID
        fetchRequest.includesPropertyValues = false
        //fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
    /// work only with SQLite persistent store
    /// https://developer.apple.com/library/archive/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html
    func batchDeleteRequest<T: NSManagedObject>(for type: T.Type) -> NSBatchDeleteRequest {
        /// this will work only with NSManagedObject(context: that we removed
        //let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        //if #available(iOS 10.0, *) {
        //    fetchRequest = type.fetchRequest()
        //} else {
        //    fetchRequest = NSFetchRequest(entityName: type.className())
        //}
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: type.className())
        fetchRequest.includesPropertyValues = false
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.resultType = .managedObjectIDResultType
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        return deleteRequest
    }
    
    func batchDeleteRequest(for entity: NSEntityDescription) -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.includesPropertyValues = false
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.resultType = .managedObjectIDResultType
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        return deleteRequest
    }
}

final class CoreDataStack {
    
    let storeType: PersistentStoreType
//    private let modelName: String
    private let container: StoreContainer
    let backgroundContext: NSManagedObjectContext
    
    /// oldAPI is iOS 9 api
    init(storeType: PersistentStoreType, modelName: String, oldApi: Bool = false) {
        self.storeType = storeType
//        self.modelName = modelName
        
        if oldApi {
            container = type(of: self).basicPersistentContainer(storeType: storeType, modelName: modelName)
        } else {
            if #available(iOS 10.0, *) {
                container = type(of: self).persistentContainer(storeType: storeType, modelName: modelName)
            } else {
                container = type(of: self).basicPersistentContainer(storeType: storeType, modelName: modelName)
            }
        }
        
        backgroundContext = container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
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
            description.shouldAddStoreAsynchronously = false
            //description.shouldMigrateStoreAutomatically = true
            //description.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [description]
        case .sqlite:
//            let description = NSPersistentStoreDescription()
//            description.shouldAddStoreAsynchronously = false
//            description.shouldMigrateStoreAutomatically = false
//            description.shouldInferMappingModelAutomatically = false
//            container.persistentStoreDescriptions = [description]
            break
        }
        
//        for store in container.persistentStoreCoordinator.persistentStores {
//            if let url = store.url {
//                do {
//                    let sourceMetadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: store.type, at: url, options: nil)
//                    let destinationModel = container.persistentStoreCoordinator.managedObjectModel
//                    let compatibile = destinationModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: sourceMetadata)
//
//                    if !compatibile, let versionHashes = sourceMetadata["NSStoreModelVersionHashes"] as? [String: Any] {
//                        let sourceEntities = Set(versionHashes.keys)
//                        let destinationEntities = Set(destinationModel.entitiesByName.keys)
//
//                        var addedEntities = Set(destinationEntities)
//                        addedEntities.subtract(sourceEntities)
//
//                        var removedEntities = Set(sourceEntities)
//                        removedEntities.subtract(destinationEntities)
//                        let modelName = (destinationModel.versionIdentifiers.first as? String) ?? ""
//                        NSLog("Core Data requires a migration to model '\(modelName)'...\nAdded: \(addedEntities)\nRemoved: \(removedEntities)")
//                    }
//
//                } catch {
//                    assertionFailure(error.localizedDescription)
//                }
//            } else {
//                assertionFailure()
//            }
//        }
        
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
