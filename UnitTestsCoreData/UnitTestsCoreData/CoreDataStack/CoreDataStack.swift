//
//  CoreDataStack.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 7/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreData

/// pass "*.xcdatamodeld" name 
/// in "private lazy var persistentContainer: NSPersistentContainer"
/// and "private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator?"
final class CoreDataStack: NSObject {
    
    // MARK: Public methods
    
    static let shared = CoreDataStack()
    
    func newBackgroundContext() -> NSManagedObjectContext {
        if #available(iOS 10.0, *) {
            /// don't set parent for newBackgroundContext(), it will crash
            /// with error "Context already has a coordinator; cannot replace"
            return persistentContainer.newBackgroundContext()
        } else {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = mainContext
            return context
        }
    }
    
    var mainContext: NSManagedObjectContext {
        if #available(iOS 10.0, *) {
            return persistentContainer.viewContext
        } else {
            return managedObjectContext
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        if #available(iOS 10.0, *) {
            persistentContainer.performBackgroundTask(block)
        } else {
            let context = newBackgroundContext()
            context.perform { 
                block(context)
            }
        }
    }
    
    // MARK: Private methods
    
    private override init() {
        super.init()
        setupMergesChangesFromParent()
    }
    
    private func setupMergesChangesFromParent() {
        if #available(iOS 10.0, *) {
            mainContext.automaticallyMergesChangesFromParent = true
        } else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(managedObjectContextDidSave),
                                                   name: .NSManagedObjectContextDidSave,
                                                   object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func managedObjectContextDidSave(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext else {
            assertionFailure()
            return
        }
        if context != mainContext, context.parent == mainContext {
            /// will be called on background queue
            mainContext.saveAsync()
        }
    }
    
    @available(iOS 10.0, *)
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UnitTestsCoreData")
        
//        let description = NSPersistentStoreDescription()
//        description.type = NSInMemoryStoreType
//        description.shouldAddStoreAsynchronously = false /// Make it simpler in test env
//        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { storeDescription, error in
            //precondition(storeDescription.type == NSInMemoryStoreType)
            
            print("CoreData: Inited \(storeDescription)")
            if let error = error {
                assertionFailure(error.localizedDescription)
                print("CoreData: Unresolved error \(error)")
                return
            }
        }
        return container
    }()
    
    ///--- available iOS 9
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            return try NSPersistentStoreCoordinator.coordinator(name: "UnitTestsCoreData")
        } catch {
            assertionFailure(error.localizedDescription)
            print("CoreData: Unresolved error \(error)")
        }
        return nil
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }()
    ///---
}


/// NSPersistentStoreCoordinator error types
public enum CoordinatorError: Error {
    /// .momd file not found
    case modelFileNotFound
    
    /// NSManagedObjectModel creation fail
    case modelCreationError
    
    /// Gettings document directory fail
    case storePathNotFound
}


enum PersistentStoreType {
    case memory
    case sqlite
}

final class PersistentContainer: NSObject {
//    open class func defaultDirectoryURL() -> URL
    
    let viewContext: NSManagedObjectContext
    private let name: String
    private let managedObjectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    // Creates a container using the model named `name` in the main bundle
    convenience init(name: String) throws {
        
        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
            throw CoordinatorError.modelFileNotFound
        }
        
        /// NSManagedObjectModel.mergedModel(from: nil)
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        
        try self.init(name: name, managedObjectModel: model)
    }
    
    init(name: String, managedObjectModel model: NSManagedObjectModel) throws {
        self.name = name
        self.managedObjectModel = model
        
//        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
//            throw CoordinatorError.storePathNotFound
//        }
//        let url = documents.appendingPathComponent("\(name).sqlite")
//        print("CoreData path: \(url.path)")
//
//        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
//                       NSInferMappingModelAutomaticallyOption: true]
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
//        try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: url, options: options)
        persistentStoreCoordinator = coordinator
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        viewContext = managedObjectContext
    }
    
    func loadPersistentStore(type: PersistentStoreType) throws {
        /// need for memory
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
