//
//  TransitionHandler.swift
//  ViperKit
//
//  Created by Bondar Yaroslav on 27/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

public typealias ConfigurationBlock = (ModuleInput) -> Void

public protocol TransitionHandler: class {
    func openModule(segueIdentifier: String)
    func openModule(segueIdentifier: String, configurationBlock: @escaping ConfigurationBlock)
    func closeCurrentModule()
}
