//
//  ListRouterInput.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

protocol ListRouterInput: class {
    func showDetail(post: Post, delegate: PostDelegate)
}
