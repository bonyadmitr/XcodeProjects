//
//  DetailRouter.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 28/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import ViperKit

final class DetailRouter {
    weak var transitionHandler: TransitionHandler?
    
    deinit {
        print("- DetailRouter")
    }
}

// MARK: - Router Input
extension DetailRouter: DetailRouterInput {
	// EXAMPLE
	//func showDetail(post: String) {
	//    transitionHandler?.openModule(segueIdentifier: "detail") { moduleInput in
	//        guard let input = moduleInput as? DetailModuleInput else { return }
	//        input.set(post: post)
	//    }
	//}
}
