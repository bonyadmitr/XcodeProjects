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
            
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
            
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
        entityDescription.addProperty(NSAttributeDescription(name: #keyPath(NoteMO.body), ofType: .stringAttributeType))
        entityDescription.addProperty(NSAttributeDescription(name: #keyPath(NoteMO.date), ofType: .dateAttributeType))
        return entityDescription
    }()
}

import CoreData

extension NSEntityDescription {
    convenience init(from classType: AnyClass) {
        let className = NSStringFromClass(classType)
        self.init()
        self.name = className
        self.managedObjectClassName = className
    }
    
    func addProperty(_ property: NSPropertyDescription) {
        self.properties.append(property)
    }
}

extension NSAttributeDescription {
    convenience init(name: String, ofType: NSAttributeType, isOptional: Bool = false) {
        self.init()
        self.name = name
        self.attributeType = ofType
        self.isOptional = isOptional
    }
}

extension NSManagedObject {
    class func fetchRequest<T: NSManagedObject>() -> NSFetchRequest<T> {
        let className = NSStringFromClass(self)//String(describing: self)
        return NSFetchRequest<T>(entityName: className)
    }
}

//protocol ClassNameable {
//    static func className() -> String
//    func className() -> String
//}
//
//extension ClassNameable {
//    static func className() -> String {
//        //return NSStringFromClass(self)
//        return String(describing: self)
//    }
//
//    func className() -> String {
//        return String(describing: type(of: self))
//    }
//}
//
//extension NSObject: ClassNameable {}
