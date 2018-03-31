//
//  ListInteractor.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit

final class ListInteractor {
    weak var output: ListInteractorOutput?
    
    let postService: PostService

    init(postService: PostService) {
        self.postService = postService
    }
}

extension ListInteractor: ListInteractorInput {
    func getPosts() {
        postService.getAll { [weak self] (posts, error) in
            if let error = error {
                self?.output?.failed(with: error)
            } else {
                self?.output?.succeed(posts: posts)
            }
            
        }
    }
}
