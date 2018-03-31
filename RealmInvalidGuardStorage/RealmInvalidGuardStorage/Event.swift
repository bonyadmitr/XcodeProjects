//
//  Event.swift
//  RealmInvalidGuardStorage
//
//  Created by Bondar Yaroslav on 27/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Realm
import RealmSwift

struct Ev: Storable {
    
    var id = -1
    var portfolioId = -1
    var date: Int64 = -1 /// milliseconds
    var title = "_"
    var descript = "_"
    var viewed = false
    
    func produce() -> Event {
        let event = Event()
        
        event.id = self.id
        
        return event
    }
    
    init() {}
    
    init(id: Int) {
        self.id = id
    }
}

final class Event: Object, StorableMirror {
    
    dynamic var id = -1
    dynamic var portfolioId = -1
    dynamic var date: Int64 = -1 /// milliseconds
    dynamic var title = "_"
    dynamic var descript = "_"
    dynamic var viewed = false
    
    
    func produce() throws -> Ev {
        var ev = Ev()
        ev.date = date
        ev.descript = descript
        ev.id = id
        ev.portfolioId = portfolioId
        ev.title = title
        return ev
    }
    
    //    convenience init?(json: [String: Any]) {
    //        let map = Map(mappingType: .fromJSON, JSON: json)
    //        self.init(map: map)
    //        mapping(map: map)
    //    }
    //
    //    required init?(map: Map) {
    //        let requiredProperties = ["id", "portfolio_id", "date", "title", "description"]
    //        let containsAllProps = requiredProperties.contains(where: { map[$0].isKeyPresent == false }) == false
    //        guard containsAllProps else {
    //            return nil
    //        }
    //        super.init()
    //    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    //    func mapping(map: Map) {
    //
    //        if map.mappingType == .toJSON {
    //            id >>> map["id"]
    //            portfolioId >>> map["portfolio_id"]
    //            date >>> map["date"]
    //            title >>> map["title"]
    //            descript >>> map["description"]
    //            viewed >>> map["viewed"]
    //            return
    //        }
    //
    //        id <- map["id"]
    //        portfolioId <- map["portfolio_id"]
    //        date <- map["date"]
    //        title <- map["title"]
    //        descript <- map["description"]
    //        viewed <- map["viewed"]
    //    }
}
