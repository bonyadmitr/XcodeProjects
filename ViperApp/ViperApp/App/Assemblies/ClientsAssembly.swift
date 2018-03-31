//
//  ClientsAssembly.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication

final class ClientsAssembly: BaseCoreAssembly {
    override init(withRoot collaborator: RootCoreAssembly) {
        super.init(withRoot: collaborator)
        container.register(.singleton) { PostClientImp() as PostClient }
    }
}
