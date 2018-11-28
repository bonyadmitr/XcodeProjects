//
//  PersistentContainer.swift
//  UnitTestsCoreData
//
//  Created by Yaroslav Bondar on 28/11/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

enum PersistentStoreType {
    case memory
    case sqlite
}

/// NSPersistentStoreCoordinator error types
public enum CoordinatorError: Error {
    /// .momd file not found
    //case modelFileNotFound
    
    /// NSManagedObjectModel creation fail
    //case modelCreationError
    
    /// Gettings document directory fail
    case storePathNotFound
}

final class PersistentContainer: NSObject {
    
    let viewContext: NSManagedObjectContext
    private let name: String
    private let managedObjectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    /// Creates a container using the model named `name` in the main bundle
    convenience init(name: String) {
        
        let moModel: NSManagedObjectModel
        if let modelURL = Bundle.main.url(forResource: name, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        {
            moModel = model
        } else {
            assertionFailure("\(name).xcdatamodeld not found in Bundle")
            moModel = NSManagedObjectModel()
        }
        
        self.init(name: name, managedObjectModel: moModel)
    }
    
    init(name: String, managedObjectModel model: NSManagedObjectModel) {
        self.name = name
        self.managedObjectModel = model
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        persistentStoreCoordinator = coordinator
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        viewContext = managedObjectContext
    }
    
    func loadPersistentStore(type: PersistentStoreType) throws {
        // TODO: - need for memory type? -
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: true]
        
        switch type {
        case .memory:
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: options)
        case .sqlite:
            guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                throw CoordinatorError.storePathNotFound
            }
            let url = documents.appendingPathComponent("\(name).sqlite")
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
            print("CoreData path: \(url.path)")
        }
    }
    
    @objc private func managedObjectContextDidSave(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext else {
            assertionFailure()
            return
        }
        if context != viewContext, context.parent == viewContext {
            /// will be called on background queue
            viewContext.saveSyncUnsafe()
        }
    }
    
    // MARK: - public
    
    func automaticallyMergesChangesFromParent() {
        /// removeObserver don't need for iOS 9+
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(managedObjectContextDidSave),
                                               name: .NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = viewContext
        return context
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = newBackgroundContext()
        context.perform {
            block(context)
        }
    }
    
    func clearAll() {
        //let storeTypes = persistentStoreCoordinator.persistentStores.map { $0.type}
        do {
            for store in persistentStoreCoordinator.persistentStores {
                if store.type == NSInMemoryStoreType {
                    try persistentStoreCoordinator.remove(store)
                    try loadPersistentStore(type: .memory)
                } else if let url = store.url {
                    try persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: store.type, options: store.options)
                    try loadPersistentStore(type: .sqlite)
                }
            }
            
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
