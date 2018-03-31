//
//  DetailModuleInput.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 28/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import ViperKit

protocol DetailModuleInput: class, ModuleInput {
    func set(post: Post)
    func set(delegate: PostDelegate)
}
