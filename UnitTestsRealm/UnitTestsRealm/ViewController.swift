//
//  ViewController.swift
//  UnitTestsRealm
//
//  Created by Bondar Yaroslav on 4/10/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit
import RealmSwift

final class RealmManager {
    
    static let shared = RealmManager()
    
    let realm: Realm!
    private let config = Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm")
    private let queue = DispatchQueue(label: "RealmManagerQueue")
    
    private init() {
        
        do {
            //Realm.Configuration(fileURL: <#T##URL?#>, inMemoryIdentifier: <#T##String?#>, syncConfiguration: <#T##SyncConfiguration?#>, encryptionKey: <#T##Data?#>, readOnly: <#T##Bool#>, schemaVersion: <#T##UInt64#>, migrationBlock: <#T##MigrationBlock?##MigrationBlock?##(Migration, UInt64) -> Void#>, deleteRealmIfMigrationNeeded: <#T##Bool#>, shouldCompactOnLaunch: <#T##((Int, Int) -> Bool)?##((Int, Int) -> Bool)?##(Int, Int) -> Bool#>, objectTypes: <#T##[Object.Type]?#>)
            
            /// We recommend holding onto a strong reference to any in-memory Realms during your app’s lifetime.
            /// inMemory realm https://realm.io/docs/swift/latest/#in-memory-realms
            
            realm = try Realm(configuration: config)
            /// defalut
            //realm.autorefresh = true
//            try realm.write {
//
//            }
//
//            realm.safeWrite {
//
//            }
        } catch {
            assertionFailure(error.localizedDescription)
            realm = nil
        }
    }
    
    func perform(handler: @escaping (Realm) -> Void) {
        queue.async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: self.config)
                    try realm.write {
                        handler(realm)
                    }
//                    DispatchQueue.main.async {
//                        self.realm.refresh()
//                    }
                    
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
        
    }
    
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

