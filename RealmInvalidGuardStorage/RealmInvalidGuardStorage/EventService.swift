//
//  EventService.swift
//  RealmInvalidGuardStorage
//
//  Created by Bondar Yaroslav on 27/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit

class EventService {
    
    let repo = try! RealmRepo<Ev, Event>()
    
    func get(at index: Int) -> Promise<Ev> {
        return repo.get(at: index)
    }
    
    func save(_ object: Ev) -> Promise<Ev> {
        return repo.save(object)
    }
    
    func save(_ objects: [Ev]) -> Promise<[Ev]> {
        return repo.save(objects)
    }
    
    var count: Int {
        return repo.count
    }
}
