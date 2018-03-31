//
//  DetailPresenter.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 28/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// Binds Detail usecase UI to business logic and manages transition logic between modules.
final class DetailPresenter {
    weak var view: DetailViewInput?
    private let interactor: DetailInteractorInput
    private let router: DetailRouterInput

    init(interactor: DetailInteractorInput, router: DetailRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    weak var delegate: PostDelegate?
    
    deinit {
        print("- DetailPresenter")
    }
}

// MARK: - View Output
extension DetailPresenter: DetailViewOutput {
    func viewIsReady() {
        view?.setupInitialState()
    }
    func viewWillDisappear(with post: Post) {
        delegate?.updated(post: post)
    }
}

// MARK: - Interactor Output
extension DetailPresenter: DetailInteractorOutput {
    func failed(with error: Error) {
        view?.show(error: error)
    }
}

// MARK: - Module Input
extension DetailPresenter: DetailModuleInput {
    func set(post: Post) {
        view?.set(post: post)
    }
    
    func set(delegate: PostDelegate) {
        self.delegate = delegate
    }
}
