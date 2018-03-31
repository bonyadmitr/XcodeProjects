//
//  MainApplication.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication

@objc(MainApplication)
class MainApplication: Application {
    override class var factory: AssembliesFactory {
        return MainAssembliesFactory()
    }
}
