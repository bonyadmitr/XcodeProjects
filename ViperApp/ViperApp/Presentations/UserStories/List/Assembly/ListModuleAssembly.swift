//
//  ListModuleAssembly.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication
import ViperKit

final class ListModuleAssembly: BaseViperAssembly {
    let tag: String? = nil

    override init(withCollaborator collaborator: RootViperAssembly) {
        super.init(withCollaborator: collaborator)
        
        container.register(tag: nil) { ListViewController() }
            .implements(ListViewInput.self, TransitionHandler.self)
            .resolvingProperties { (container, controller) in
                controller.output = try container.resolve()
                controller.moduleInput = try container.resolve()
            }
        container.register { ListPresenter(interactor: $0, router: $1) }
            .implements(ModuleInput.self, ListViewOutput.self, ListInteractorOutput.self)
            .resolvingProperties { [unowned self] (container, presenter) in
                presenter.view = try container.resolve(tag: self.tag)
            }
        container.register { ListRouter() }
            .implements(ListRouterInput.self)
            .resolvingProperties { [unowned self] (container, router) in
                router.transitionHandler = try container.resolve(tag: self.tag)
            }
        container.register { ListInteractor(postService: $0) }
            .implements(ListInteractorInput.self)
            .resolvingProperties { (container, interactor) in
                interactor.output = try container.resolve()
            }
    }
}
