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
}

@available(iOS 10.0, *)
extension NSPersistentContainer: StoreContainer {
    func clearAll() {
        do {
            for store in persistentStoreCoordinator.persistentStores {
                try persistentStoreCoordinator.remove(store)
            }
            
            loadPersistentStores { storeDescription, error in
                print("CoreData: Inited \(storeDescription)")
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    print("CoreData: Unresolved error \(error)")
                    return
                }
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
