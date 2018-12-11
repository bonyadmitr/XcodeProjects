//
//  StoreContainer.swift
//  UnitTestsCoreData
//
//  Created by Yaroslav Bondar on 28/11/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

protocol StoreContainer {
    var viewContext: NSManagedObjectContext { get }
    func newBackgroundContext() -> NSManagedObjectContext
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func automaticallyMergesChangesFromParent()
    func clearAll()
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }
}

@available(iOS 10.0, *)
extension NSPersistentContainer: StoreContainer {
    func clearAll() {
        do {
            for store in persistentStoreCoordinator.persistentStores {
                if store.type == NSInMemoryStoreType {
                    try persistentStoreCoordinator.remove(store)
//                    try loadPersistentStore(type: .memory)
                } else if let url = store.url {
                    try persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: store.type, options: store.options)
//                    try loadPersistentStore(type: .sqlite)
                }
            }
            loadPersistentStores { storeDescription, error in
                //print("CoreData: Inited \(storeDescription)")
                print("- CoreData: Inited clearAll")
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    print("CoreData: Unresolved error \(error)")
                    return
                }
            }
            //viewContext.reset()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func automaticallyMergesChangesFromParent() {
        viewContext.automaticallyMergesChangesFromParent = true
    }
    
//    private func loadPersistentStore(type: PersistentStoreType) throws {
//        // TODO: - need for memory type? -
//        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
//                       NSInferMappingModelAutomaticallyOption: true]
//
//        switch type {
//        case .memory:
//            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: options)
//        case .sqlite:
//            guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
//                throw CoordinatorError.storePathNotFound
//            }
//            let url = documents.appendingPathComponent("\(name).sqlite")
//            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
//            print("CoreData path: \(url.path)")
//        }
//    }
}

extension PersistentContainer: StoreContainer {}
