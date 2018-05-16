//
//  SomeEntity.swift
//  DataSourceGeneric
//
//  Created by Bondar Yaroslav on 20/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

class SomeEntity {
    var title = ""
    var name = ""
    
    static func random() -> SomeEntity {
        let q = SomeEntity()
        q.title = "title iqeiuqhwhqweoqo"
        q.name = "name fhbfidsfbfkdk"
        return q
    }
}
