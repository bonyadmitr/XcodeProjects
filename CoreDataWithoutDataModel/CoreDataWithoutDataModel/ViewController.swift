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
        // Do any additional setup after loading the view.
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
