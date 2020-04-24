//
//  ViewController.swift
//  CoreDataWithoutDataModel
//
//  Created by Bondar Yaroslav on 4/24/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataStack.shared.performBackgroundTask { context in
            
            let note = NoteMO(context: context)
            note.body = "body 123 eurwieur"
            note.date = Date()
            
            context.safeSave()
            
            CoreDataStack.shared.performBackgroundTask { context in
                
                let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
                //try! request.execute()
                //context.execute(request)
                let items = try! context.fetch(request)
                print(items)
                print()

            }
        }
        
    }

}

import CoreData

@objc(NoteMO)
public class NoteMO: NSManagedObject {
    
    @NSManaged public var body: String
    @NSManaged public var date: Date
    
    //convenience init(context: NSManagedObjectContext, body: String, date: Date) {
    //    self.init(context: context)
    //    self.body = body
    //    self.date = date
    //}
    
    static let entityDescription: NSEntityDescription = {
        let entityDescription = NSEntityDescription(from: NoteMO.self)
        entityDescription.addProperty(NSAttributeDescription(name: #keyPath(NoteMO.body), type: .stringAttributeType))
        entityDescription.addProperty(NSAttributeDescription(name: #keyPath(NoteMO.date), type: .dateAttributeType))
        return entityDescription
    }()
}
