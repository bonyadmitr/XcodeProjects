//
//  ViewController.swift
//  RealmTests
//
//  Created by Yaroslav Bondr on 20.11.2020.
//

import UIKit
import Realm
import RealmSwift


final class LoginRequestForApi {
  var username: String?
  var password: String?
}
final class LoginRequestForImap {
  var username: String?
  var password: String?
}
final class MailListItemForApi {
  var title: String?
}
final class MailListItemForImap {
  var title: String?
}

func login() {
    
    let isImap = true
    
    
    
}

protocol Login {
    associatedtype Model
    func login(request: Model)
}
class LoginApi: Login {
    func login(request: String) {
        
    }
}
class LoginImap: Login {
    func login(request: Int) {
        
    }
}

//func getProviderForLogin(request: Any) -> AuthProviderProtocol {
//  switch request {
//  case is LoginRequestForApi:
//    return AuthService()
//  case is LoginRequestForImap:
//    return AuthImap()
//  default:
//    return AuthService()
//  }
//}
//func getProviderForMailList(request: Any) -> MailListProviderProtocol {
//  switch request {
//  case is MailListItemForApi:
//    return MailListService()
//  case is MailListItemForImap:
//    return MailListImap()
//  default:
//    return MailListService()
//  }
//}










class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
//        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//        let realm = try! Realm(configuration: config)
        
        /// Crash when using deleteRealmIfMigrationNeeded with Realm in Swift https://stackoverflow.com/a/47530251/5893286
        /// solution:  turn off the Realm Browser if you have it open
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm()
        
        let user = User()
        user.id = "1"
        user.name = "user 111"
        
        let note = Note()
        note.id = "1"
        note.title = "title 1"
        note.user = user
        
//        try! realm.write {
//            realm.add(note, update: .modified)
//        }
        
        let oldNote = realm.object(ofType: Note.self, forPrimaryKey: "1")!
        print(oldNote.user!.name)
        
        try! realm.write {
            realm.add(note, update: .modified)
//            oldNote.update(by: note)
//            oldNote.user = note.user
//            oldNote.title = note.title
        }


        let oldNote2 = realm.object(ofType: Note.self, forPrimaryKey: "1")!
        print(oldNote2.user!.name)
        
        
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
