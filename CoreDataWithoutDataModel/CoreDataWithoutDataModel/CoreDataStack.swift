import CoreData

/// CoreData without .XCDataModel https://habr.com/ru/post/498708/
extension CoreDataStack {
    
    private static let moModel: NSManagedObjectModel = {
        let model = NSManagedObjectModel()
        model.entities = [NoteMO.entityDescription]
        return model
    }()
    
    static let shared = CoreDataStack(storeType: .disk, modelName: "CoreDataStorage", managedObjectModel: moModel)
}

/// no need @objc(NSManagedObject SUBCLASS) CoreDataStack(storeType: .memoty
final class CoreDataStack {
    
    enum PersistentStoreType {
        case memory
        case disk //sqlite
    }
    
    private let storeType: PersistentStoreType
    private let container: NSPersistentContainer
    
    init(storeType: PersistentStoreType, modelName: String, managedObjectModel: NSManagedObjectModel? = nil) {
        self.storeType = storeType
        
        container = type(of: self).persistentContainer(storeType: storeType,
                                                       modelName: modelName,
                                                       managedObjectModel: managedObjectModel)
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
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
    
    func managedObjectID(for url: URL) -> NSManagedObjectID? {
        return container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url)
    }
    
    private static func persistentContainer(storeType: PersistentStoreType,
                                            modelName: String,
                                            managedObjectModel: NSManagedObjectModel?) -> NSPersistentContainer {
        
        let container: NSPersistentContainer
        if let managedObjectModel = managedObjectModel {
            container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        } else {
            container = NSPersistentContainer(name: modelName)
        }
        
        switch storeType {
        case .memory:
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            //description.shouldMigrateStoreAutomatically = true
            //description.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [description]
            
        case .disk:
            /// defalut disk realization
            break
            
            //guard let documentDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            //    fatalError("Unable to resolve document directory")
            //}
            //let storeName = modelName + ".sqlite"
            //let storeUrl = documentDirURL.appendingPathComponent(storeName)
            //
            //let description = NSPersistentStoreDescription(url: storeUrl)
            //description.type = NSSQLiteStoreType
            //description.setOption(FileProtectionType.none as NSObject, forKey: NSPersistentStoreFileProtectionKey)
            ////description.shouldMigrateStoreAutomatically = false
            ////description.shouldInferMappingModelAutomatically = false
            //container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            } else if let coreDataPath = storeDescription.url?.deletingLastPathComponent().path {
                /// used to eazy copy/past to Finder - Go - Go to folder
                print("- CoreData: Inited at \(coreDataPath))")
            } else {
                assertionFailure("should never be called")
            }
        }
        return container
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
//
//extension NSPersistentContainer {
//
//    func automaticallyMergesChangesFromParent() {
//        viewContext.automaticallyMergesChangesFromParent = true
//    }
//
//    func recreateStore(completion: @escaping (Error?) -> Void) {
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
//                    completion(error)
//                } else {
//                    completion(nil)
//                }
//            }
//        } catch {
//            assertionFailure(error.debugDescription)
//            completion(error)
//        }
//    }
//}
//
//typealias CoreDataSaveStatusHandler = (CoreDataSaveStatus) -> Void
//
//enum CoreDataSaveStatus {
//    case saved
//    case hasNoChanges
//    case rolledBack(Error)
//}
