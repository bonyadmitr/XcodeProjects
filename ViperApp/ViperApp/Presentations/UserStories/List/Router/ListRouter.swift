//
//  ListRouter.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import ViperKit

final class ListRouter {
    weak var transitionHandler: TransitionHandler?
}

// MARK: - Router Input
extension ListRouter: ListRouterInput {
    func showDetail(post: Post, delegate: PostDelegate) {
        transitionHandler?.openModule(segueIdentifier: "detail") { moduleInput in
            guard let input = moduleInput as? DetailModuleInput else { return }
            input.set(post: post)
            input.set(delegate: delegate)
        }
    }
    
    func show_MODULE_NAME() {
//        transitionHandler?.openModule(segueIdentifier: "personalInfo", transitionDelegate: transition)
    }
    
    func show_MODULE_NAME2() {
//        transitionHandler?.openModule(segueIdentifier: "detail") { moduleInput in
//            guard let input = moduleInput as? DetailModuleInput else { return }
//            input.set(post: post)
//            input.set(delegate: delegate)
//        }
    }
}
