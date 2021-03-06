//
//  ViewController.swift
//  UnitTestsRealm
//
//  Created by Bondar Yaroslav on 4/10/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit
import RealmSwift

/// just place breakpoint inside method:
/// static NSException *RLMException(NSString *reason, NSDictionary *additionalUserInfo)
/// source https://stackoverflow.com/a/44762897/5893286
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
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        /// will not invoke until scrolling end (RunLoop.Mode.tracking)
        notificationToken = folders.observe { [weak self] changes in
            guard let tableView = self?.tableView else {
                return
            }

            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                // Always apply updates in the following order: deletions, insertions, then modifications.
                // Handling insertions before deletions may result in unexpected behavior.
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }

        }
        
        saveItems()
        deleteItems()
    }
    
    func deleteItems() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            try! RealmManager.shared.realm.safeWrite {
                RealmManager.shared.realm.delete(self.folders)
            }
        }
        
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//            RealmManager.shared.perform { realm in
//                let folders = realm.objects(Folder.self)
//                realm.delete(folders)
//            }
//        }
        
    }
    
    func saveItems() {
        print("- started")
        
        let newFolders: [Folder] = (1...1000).map {
            let folder = Folder()
            folder.id = $0
            folder.title = "Folder \($0)"
            return folder
        }
        
        RealmManager.shared.perform { [weak self] realm in
            realm.add(newFolders)
            print("- saved")
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //    self?.tableView.reloadData()
            //}
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
        
        /// guard for deleting on main thread realm
        if indexPath.row <= folders.count - 1 {
            cell.textLabel?.text = folders[indexPath.row].title
        } else {
            cell.textLabel?.text = "--------"
        }
        return cell
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
