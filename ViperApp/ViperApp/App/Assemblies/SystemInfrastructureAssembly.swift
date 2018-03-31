//
//  SystemInfrastructureAssembly.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication
//import Cocoa

final class SystemInfrastructureAssembly: BaseCoreAssembly {
    
    override init(withRoot collaborator: RootCoreAssembly) {
        super.init(withRoot: collaborator)
        
        #if os(iOS)
        container.register(.eagerSingleton) { UIWindow(frame: UIScreen.main.bounds) }
        #elseif os(macOS)
//        container.register { storyboards.initialStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "qqq")) as! NSWindowController }
        #endif
        container.register(.eagerSingleton) { Bundle.main }
//        container.register(.eagerSingleton) { UserDefaults.standard }
    }
}
