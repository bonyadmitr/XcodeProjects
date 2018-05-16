//
//  ViewController.swift
//  DataBaseTest
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreData

let numberOfUsers = 1_000_000
    
class TimeMeasurer {
    
    static let shared = TimeMeasurer()
    
    private var startTime: Date!
    
    func start() {
        startTime = Date()
    }
    func finish(title: String = "TimeMeasurer finished:") {
        print(title, Date().timeIntervalSince(startTime))
    }
    
    func measure(title: String = "TimeMeasurer measured:", handler: ()->Void) {
        let startTime = Date()
        handler()
        print(title, Date().timeIntervalSince(startTime))
    }
}


import Realm
import RealmSwift

final class UserRealm: Object {
    @objc dynamic var name: String?
    @objc dynamic var age: Int64 = 0
}

/// https://realm.io/docs/swift/latest#getting-started

/// http://five.agency/how-to-import-a-large-data-set-using-core-data/
/// http://bestkora.com/IosDeveloper/core-data-v-swift-3-v-ios-10/
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        User.fetchRequest()
        
//        createCoreData()
//        createCoreData2()
//        createCoreDataMain()
//        createRealm()
        
//        printRealm()
//        printCoreData()
    }
    
    func printCoreData() {
        CoreDataManager.persistentContainer.performBackgroundTask { context in
            TimeMeasurer.shared.start()
            
            let request: NSFetchRequest<User> = User.fetchRequest()
            let users = try! context.fetch(request)
            print(users.count)
            TimeMeasurer.shared.finish(title: "core data get")
        }
    }
    
    func printRealm() {
        
        DispatchQueue.global().async {
            let realm = try! Realm()
            TimeMeasurer.shared.start()
            
            let users = Array(realm.objects(UserRealm.self))
            print(users.count)
            TimeMeasurer.shared.finish(title: "realm get")
        }
    }
    
    func createCoreData() {
        
        CoreDataManager.persistentContainer.performBackgroundTask { context in
            TimeMeasurer.shared.start()
            
            for i in 1...numberOfUsers {
                autoreleasepool {
                    let user = User(context: context)
                    user.id = Int64(i)
                    user.name = "Name \(i)"
                }
            }
            
            try? context.save()
            TimeMeasurer.shared.finish(title: "core data created")
        }

    }
    
    func createCoreData2() {
        
        TimeMeasurer.shared.start()
        
        
            
            
            for i in 1...numberOfUsers {
                CoreDataManager.persistentContainer.performBackgroundTask { context in
//                    autoreleasepool {
                        let user = User(context: context)
                        user.id = Int64(i)
                        user.name = "Name \(i)"
//                    }
                    try? context.save()
                }
            }
            
        
            TimeMeasurer.shared.finish(title: "core data created")
        
    }
    
    func createCoreDataMain() {
        let context = CoreDataManager.persistentContainer.viewContext
        TimeMeasurer.shared.start()
        
        for i in 1...numberOfUsers {
            let user = User(context: context)
            user.id = Int64(i)
            user.name = "Name \(i)"
        }
        
        try? context.save()
        TimeMeasurer.shared.finish(title: "core data created")

    }
    
    func createRealm() {
        
        DispatchQueue.global().async {
            
            let realm = try! Realm()
            TimeMeasurer.shared.start()
            
            try? realm.write {
                for i in 1...numberOfUsers {
                    let user = UserRealm()
                    user.name = "realm \(i)"
                    user.age = Int64(i)
                    realm.add(user)
                }
                TimeMeasurer.shared.finish(title: "Realm saved")
            }
            
        }

    }
}

