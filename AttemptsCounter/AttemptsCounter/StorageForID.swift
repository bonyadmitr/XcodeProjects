//
//  StorageForID.swift
//  AttemptsCounter
//
//  Created by Bondar Yaroslav on 3/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol StorageForID {
    init(id: String)
    func set(_ object: Any, for key: String) 
    func object(for key: String) -> Any?
}
