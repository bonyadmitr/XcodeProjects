//
//  CoreDataStack.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 7/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

extension CoreDataStack {
    static let shared = CoreDataStack(storeType: .memory, modelName: "UnitTestsCoreData")
}

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
