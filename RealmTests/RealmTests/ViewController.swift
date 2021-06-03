//
//  ViewController.swift
//  RealmTests
//
//  Created by Yaroslav Bondr on 20.11.2020.
//

import UIKit
import Realm
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

final class Note: IdObject {
    @objc dynamic var title = ""
    @objc dynamic var user: User?
}

final class User: IdObject {
    @objc dynamic var name = ""
}


class IdObject: Object {
    @objc dynamic var id = ""
    
    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
}

// TODO: type(of: realmObject) == type(of: oldRealmObject)
extension Object {
    
    func update(by new: Object) {
        /// 'Primary key can't be changed after an object is inserted.'
        for property in new.objectSchema.properties {
            
            guard
                property.name != Self.primaryKey(),
                let newValue = new.value(forKey: property.name)
            else {
                  //, let oldValue = value(forKey: property.name), newValue != oldValue else {
                continue
            }
            
            
//            print(property.name, newValue)
            
            if let realmObject = newValue as? Object,
               let oldRealmObject = self.value(forKey: property.name) as? Object,
               type(of: realmObject) == type(of: oldRealmObject)
            {
                oldRealmObject.update(by: realmObject)
            } else { // Then it is a primitive
                setValue(newValue, forKey: property.name)
            }
        }
        
    }
}
protocol DetachableObject: AnyObject {
    func detached() -> Self
}

extension Object: DetachableObject {
    
    func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else {
                continue
            }
            if let detachable = value as? DetachableObject {
                detached.setValue(detachable.detached(), forKey: property.name)
            } else { // Then it is a primitive
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}

extension List: DetachableObject {
    func detached() -> List<Element> {
        let result = List<Element>()
        forEach {
            if let detachableObject = $0 as? DetachableObject,
               let element = detachableObject.detached() as? Element {
                result.append(element)
            } else { // Then it is a primitive
                result.append($0)
            }
        }
        return result
    }
}
