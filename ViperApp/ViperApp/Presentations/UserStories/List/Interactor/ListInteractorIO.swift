//
//  ListInteractorIO.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

// MARK: - Interactor Input
protocol ListInteractorInput: class {
    func getPosts()
}

// MARK: - Interactor Output
protocol ListInteractorOutput: class {
	func failed(with error: Error)
    func succeed(posts: [Post])
}
