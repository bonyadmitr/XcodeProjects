//
//  AppDelegate.swift
//  ProductsList
//
//  Created by Bondar Yaroslav on 11/15/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _ = CoreDataStack.shared
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

import CoreData

extension CoreDataStack {
    static let shared = CoreDataStack(storeType: .sqlite, modelName: "ProductsList")
}

final class CoreDataStack {
    
    enum PersistentStoreType {
        case memory
        case sqlite
    }
    
    let storeType: PersistentStoreType
//    private let modelName: String
    private let container: NSPersistentContainer
    
    /// oldAPI is iOS 9 api
    init(storeType: PersistentStoreType, modelName: String) {
        self.storeType = storeType
//        self.modelName = modelName
        
        container = type(of: self).persistentContainer(storeType: storeType, modelName: modelName)
        container.automaticallyMergesChangesFromParent()
        
        // TODO: check
        // TODO: maybe should be in the "loadPersistentStores"
        /// to avoid duplicating objects
        //viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
    
    func recreateStore() {
        container.recreateStore() { error in
            if let error = error {
                assertionFailure(error.debugDescription)
            } else {
                print("Core data store recreated")
            }
            
        }
    }
    
    private static func persistentContainer(storeType: PersistentStoreType, modelName: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: modelName)
        
        switch storeType {
        case .memory:
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            //description.shouldMigrateStoreAutomatically = true
            //description.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [description]
        case .sqlite:
            break
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.debugDescription)
            } else {
                print("- CoreData: Inited")
            }
        }
        return container
    }
}

extension NSPersistentContainer {
    
    func recreateStore(complition: @escaping (Error?) -> Void) {
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
                    assertionFailure(error.debugDescription)
                    complition(error)
                } else {
                    complition(nil)
                }
            }
        } catch {
            assertionFailure(error.debugDescription)
            complition(error)
        }
    }
    
    func automaticallyMergesChangesFromParent() {
        viewContext.automaticallyMergesChangesFromParent = true
    }
}

protocol ClassName {
    static func className() -> String
    func className() -> String
}

extension ClassName {
    static func className() -> String {
        return String(describing: self.self)
    }
    
    func className() -> String {
        return String(describing: type(of: self))
    }
}

extension NSObject: ClassName {}
