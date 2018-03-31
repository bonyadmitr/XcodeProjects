//
//  DetailViewIO.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 28/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol DetailViewInput: class {
    func setupInitialState()
    func show(error: Error)
    func set(post: Post)
}

protocol DetailViewOutput: class {
    func viewIsReady()
    func viewWillDisappear(with post: Post)
}
