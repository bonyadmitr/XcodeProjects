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
class IdObject: Object {
    @objc dynamic var id = ""
    
    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
}
