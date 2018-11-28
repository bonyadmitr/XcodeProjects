//
//  NSPersistentStoreCoordinator+Extensions.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 30/07/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

extension NSPersistentStoreCoordinator {
    

    
    /// Return NSPersistentStoreCoordinator
    private convenience init(name: String) throws {
        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
            throw CoordinatorError.modelFileNotFound
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        self.init(managedObjectModel: model)
    }
    
    /// Return NSPersistentStoreCoordinator with set coordinator
    static func coordinator(name: String) throws -> NSPersistentStoreCoordinator? {
        let coordinator = try NSPersistentStoreCoordinator(name: name)
        
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            throw CoordinatorError.storePathNotFound
        }
        
        do {
            let url = documents.appendingPathComponent("\(name).sqlite")
            print("CoreData path: \(url.path)")
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            assertionFailure(error.localizedDescription)
            throw error
        }
        
        return coordinator
    }
}
