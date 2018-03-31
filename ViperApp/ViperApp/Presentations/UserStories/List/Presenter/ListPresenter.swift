//
//  ListPresenter.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol PostDelegate: class {
    func updated(post: Post)
}

final class ListPresenter {
    weak var view: ListViewInput?
    private let interactor: ListInteractorInput
    private let router: ListRouterInput

    init(interactor: ListInteractorInput, router: ListRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - View Output
extension ListPresenter: ListViewOutput {
    func viewIsReady() {
        view?.setupInitialState()
        interactor.getPosts()
    }
    
    func didSelect(post: Post) {
        router.showDetail(post: post, delegate: self)
    }
}

// MARK: - Interactor Output
extension ListPresenter: ListInteractorOutput {
    func succeed(posts: [Post]) {
        view?.diplay(posts: posts)
    }
    
    func failed(with error: Error) {
        view?.show(error: error)
    }
}

// MARK: - Module Input
extension ListPresenter: ListModuleInput {
    
}

// MARK: - PostDelegate
extension ListPresenter: PostDelegate {
    func updated(post: Post) {
        view?.update(post: post)
    }
}
