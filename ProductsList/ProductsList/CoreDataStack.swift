import CoreData

extension CoreDataStack {
    static let shared = CoreDataStack(storeType: .sqlite, modelName: "ProductsList")
}

final class CoreDataStack {
    
    enum PersistentStoreType {
        case memory
        case sqlite
    }
    
    let storeType: PersistentStoreType
//    private let modelName: String
    private let container: NSPersistentContainer
    
    /// oldAPI is iOS 9 api
    init(storeType: PersistentStoreType, modelName: String) {
        self.storeType = storeType
//        self.modelName = modelName
        
        container = type(of: self).persistentContainer(storeType: storeType, modelName: modelName)
        container.automaticallyMergesChangesFromParent()
        
        // TODO: check
        // TODO: maybe should be in the "loadPersistentStores"
        /// to avoid duplicating objects
        //viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
    
//    func recreateStore() {
//        container.recreateStore() { error in
//            if let error = error {
//                assertionFailure(error.debugDescription)
//            } else {
//                print("Core data store recreated")
//            }
//
//        }
//    }
    
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
            break
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.debugDescription)
            } else {
                print("- CoreData: Inited")
            }
        }
        return container
    }
}

//extension CoreDataStack {
//
//    /// working ONLY with NSSQLiteStoreType
//    /// https://stackoverflow.com/a/50154532/5893286
//    func deleteAll(completion: CoreDataSaveStatusHandler? = nil) {
//        performBackgroundTask { context in
//
//            switch self.storeType {
//            case .sqlite:
//                do {
//                    let objectIDs = try self.container.persistentStoreCoordinator.managedObjectModel.entities
//                        .compactMap { self.batchDeleteRequest(for: $0) }
//                        .compactMap { try context.execute($0) as? NSBatchDeleteResult }
//                        .compactMap { $0.result as? [NSManagedObjectID] }
//                        .flatMap { $0 }
//
//                    /// long operation. need only to update NSFetchedResultsController.
//                    /// for logout can be removed.
//                    /// context.parent is nil iOS 10+ so used viewContext
//                    let changes = [NSDeletedObjectsKey: objectIDs]
//                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.viewContext])
//                    completion?(.saved)
//
//                } catch {
//                    assertionFailure(error.localizedDescription)
//                    context.rollback()
//                    completion?(.rolledBack(error))
//                }
//
//            case .memory:
//                do {
//                    /// very long operation: 10 seconds for 10_000 objects
//                    try [ProductItemDB.self]
//                        .map { self.deleteRequest(for: $0) }
//                        .forEach { fetchRequest in
//                            let models = try context.fetch(fetchRequest)
//                            models.forEach { context.delete($0) }
//                    }
//                    try context.save()
//                    completion?(.saved)
//                } catch {
//                    assertionFailure(error.localizedDescription)
//                    context.rollback()
//                    completion?(.rolledBack(error))
//                }
//
//            }
//
//        }
//
//    }
//
//    private func batchDeleteRequest(for entity: NSEntityDescription) -> NSBatchDeleteRequest {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//        fetchRequest.entity = entity
//        fetchRequest.includesPropertyValues = false
//        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.resultType = .managedObjectIDResultType
//
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        deleteRequest.resultType = .resultTypeObjectIDs
//        return deleteRequest
//    }
//
//    private func deleteRequest<T: NSManagedObject>(for type: T.Type) -> NSFetchRequest<T> {
//        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: type.className())
//        ///only fetch the managedObjectID
//        fetchRequest.includesPropertyValues = false
//        //fetchRequest.returnsObjectsAsFaults = false
//        return fetchRequest
//    }
//}

extension NSPersistentContainer {

    func automaticallyMergesChangesFromParent() {
        viewContext.automaticallyMergesChangesFromParent = true
    }
    
//    func recreateStore(complition: @escaping (Error?) -> Void) {
//        do {
//            viewContext.reset()
//            for store in persistentStoreCoordinator.persistentStores {
//                if store.type == NSInMemoryStoreType {
//                    try persistentStoreCoordinator.remove(store)
//                } else if let url = store.url {
//                    try persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: store.type, options: store.options)
//                }
//            }
//            loadPersistentStores { storeDescription, error in
//                if let error = error {
//                    assertionFailure(error.debugDescription)
//                    complition(error)
//                } else {
//                    complition(nil)
//                }
//            }
//        } catch {
//            assertionFailure(error.debugDescription)
//            complition(error)
//        }
//    }
}

//typealias CoreDataSaveStatusHandler = (CoreDataSaveStatus) -> Void
//
//enum CoreDataSaveStatus {
//    case saved
//    case hasNoChanges
//    case rolledBack(Error)
//}
