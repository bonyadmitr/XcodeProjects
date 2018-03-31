//
//  ServicesAssembly.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication

final class ServicesAssembly: BaseServiceAssembly {
    override init(withCollaborator collaborator: RootServicesAssembly) {
        super.init(withCollaborator: collaborator)
        container.register(.eagerSingleton) { PostServiceImp(postClient: $0, postStorage: $1) as PostService }
        bootstrap()
    }
}
