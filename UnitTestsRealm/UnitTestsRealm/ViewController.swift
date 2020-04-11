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

final class Folder: Object {
    @objc dynamic var title = ""
    @objc dynamic var id: Int = 0
    
    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
}



class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var folders: Results<Folder>! = RealmManager.shared.realm
        .objects(Folder.self)
        //.sorted(byKeyPath: #keyPath(Folder.title))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        


        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            print("- started")
            
            let newFolders: [Folder] = (1...100).map {
                let folder = Folder()
                folder.id = $0
                folder.title = "Folder \($0)"
                return folder
            }
            
            RealmManager.shared.perform { [weak self] realm in
                realm.add(newFolders)
                print("- saved")
                
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
            }
        }
        
        
        
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = folders[indexPath.row].title
        return cell
    }
}

