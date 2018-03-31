//
//  PostStorage.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit
import RealmSwift

protocol PostStorage {
    func getAll() -> Promise<[PostRealm]>
    func save(_ objects: [PostRealm]) -> Promise<[PostRealm]>
}

final class PostStorageRealm: RealmGetAll, RealmSaveMany, PostStorage {
    typealias Entity = PostRealm
}
