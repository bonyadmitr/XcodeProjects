//
//  ListViewIO.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

//import ViperKit

protocol ListViewInput: class {
    func setupInitialState()
    func show(error: Error)
    func update(post: Post)
    func diplay(posts: [Post])
}

protocol ListViewOutput: class {
    func viewIsReady()
    func didSelect(post: Post)
}
