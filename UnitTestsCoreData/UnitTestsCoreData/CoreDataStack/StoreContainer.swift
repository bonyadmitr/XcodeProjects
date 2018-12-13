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
            viewContext.reset()
            for store in persistentStoreCoordinator.persistentStores {
                if store.type == NSInMemoryStoreType {
                    try persistentStoreCoordinator.remove(store)
                } else if let url = store.url {
                    try persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: store.type, options: store.options)
                }
            }
            loadPersistentStores { storeDescription, error in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    print("CoreData: Unresolved error \(error)")
                    return
                }
                //print("CoreData: Inited \(storeDescription)")
                print("- CoreData: Inited clearAll")
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func automaticallyMergesChangesFromParent() {
        viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistentContainer: StoreContainer {}
