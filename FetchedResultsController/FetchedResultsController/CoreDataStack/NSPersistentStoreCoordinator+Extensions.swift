//
//  NSPersistentStoreCoordinator+Extensions.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 30/07/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreData

extension NSPersistentStoreCoordinator {
    
    /// NSPersistentStoreCoordinator error types
    public enum CoordinatorError: Error {
        /// .momd file not found
        case modelFileNotFound
        /// NSManagedObjectModel creation fail
        case modelCreationError
        /// Gettings document directory fail
        case storePathNotFound
    }
    
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
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            throw error
        }
        
        return coordinator
    }
}
