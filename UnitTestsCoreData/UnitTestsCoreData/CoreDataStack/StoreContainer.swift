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
}

@available(iOS 10.0, *)
extension NSPersistentContainer: StoreContainer {
    func automaticallyMergesChangesFromParent() {
        viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistentContainer: StoreContainer {}
