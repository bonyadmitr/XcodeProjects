//
//  DetailModuleAssembly.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 28/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication
import ViperKit

final class DetailModuleAssembly: BaseViperAssembly {
    let tag: String? = nil

    override init(withCollaborator collaborator: RootViperAssembly) {
        super.init(withCollaborator: collaborator)
        
        container.register(tag: tag) { DetailViewController() }
            .implements(DetailViewInput.self, TransitionHandler.self)
            .resolvingProperties { (container, controller) in
                controller.output = try container.resolve()
                controller.moduleInput = try container.resolve()
            }
        container.register { DetailPresenter(interactor: $0, router: $1) }
            .implements(ModuleInput.self, DetailViewOutput.self, DetailInteractorOutput.self)
            .resolvingProperties { [unowned self] (container, presenter) in
                presenter.view = try container.resolve(tag: self.tag)
            }
        container.register { DetailRouter() }
            .implements(DetailRouterInput.self)
            .resolvingProperties { [unowned self] (container, router) in
                router.transitionHandler = try container.resolve(tag: self.tag)
            }
        container.register { DetailInteractor() }
            .implements(DetailInteractorInput.self)
            .resolvingProperties { (container, interactor) in
                interactor.output = try container.resolve()
            }
    }
    
    deinit {
        print("- DetailModuleAssembly")
    }
}
