//
//  CoreDataStack.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 7/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreData

extension CoreDataStack {
    static let shared = CoreDataStack(storeType: .memory, modelName: "UnitTestsCoreData")
}


protocol StoreContainer {
    var viewContext: NSManagedObjectContext { get }
    func newBackgroundContext() -> NSManagedObjectContext
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func automaticallyMergesChangesFromParent()
}

@available(iOS 10.0, *)
extension NSPersistentContainer: StoreContainer {
    func automaticallyMergesChangesFromParent() {
        viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistentContainer: StoreContainer {}

final class CoreDataStack {
    
//    let storeType: PersistentStoreType
//    private let modelName: String
    private let container: StoreContainer
    
    init(storeType: PersistentStoreType, modelName: String) {
//        self.storeType = storeType
//        self.modelName = modelName
        
        if #available(iOS 10.0, *) {
            container = type(of: self).persistentContainer(storeType: storeType, modelName: modelName)
        } else {
            container = type(of: self).basicPersistentContainer(storeType: storeType, modelName: modelName)
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
    
    
    @available(iOS 10.0, *)
    static func persistentContainer(storeType: PersistentStoreType, modelName: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: modelName)
        
        switch storeType {
        case .memory:
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            // TODO: - need shouldAddStoreAsynchronously? -
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]
        case .sqlite:
            break
        }
        
        container.loadPersistentStores { storeDescription, error in
            print("CoreData: Inited \(storeDescription)")
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


/// NSPersistentStoreCoordinator error types
public enum CoordinatorError: Error {
    /// .momd file not found
    //case modelFileNotFound
    
    /// NSManagedObjectModel creation fail
    //case modelCreationError
    
    /// Gettings document directory fail
    case storePathNotFound
}


enum PersistentStoreType {
    case memory
    case sqlite
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
}
