//
//  StoryboardsAssembly.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//
import DipApplication

#if os(iOS)
final class StoryboardsAssembly: BaseCoreAssembly {
    
    /// set in Info.plist !!!
    let storyboardTag = "Main"
    
    var initialStoryboard: UIStoryboard {
        return resolve(tag: storyboardTag)
    }

    init(withRoot root: RootCoreAssembly, systemInfrastructure: SystemInfrastructureAssembly) {
        super.init(withRoot: root)
        container.register(.singleton, tag: storyboardTag) { UIStoryboard(name: self.storyboardTag, bundle: $0) }
        bootstrap()
    }
}

#elseif os(macOS)
import Cocoa
final class StoryboardsAssembly: BaseCoreAssembly {
    
    /// set in Info.plist !!!
    let storyboardTag = "Main"
    
    var initialStoryboard: NSStoryboard {
        return resolve(tag: storyboardTag)
    }
    
    init(withRoot root: RootCoreAssembly, systemInfrastructure: SystemInfrastructureAssembly) {
        super.init(withRoot: root)
        container.register(.singleton, tag: storyboardTag) { NSStoryboard(name: NSStoryboard.Name(rawValue: self.storyboardTag), bundle: $0) }
        bootstrap()
    }
}
#endif
