//
//  AppDelegatesAssembly.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication
#if os(macOS)
import Cocoa
#endif
// swiftlint:disable delegate
final class AppDelegatesAssembly: BaseLaunchAssembly {
    var appDelegate: AppDelegate {
        return resolve()
    }
    
    init(root: RootLaunchAssembly, storyboards: StoryboardsAssembly) {
        super.init(withCollaborator: root)
        
        #if os(iOS)
        container.register { AppDelegate(mainRouter: $0) }
            
        #elseif os(macOS)
            
        container.register { storyboards.initialStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "qqq")) as! NSWindowController }
        container.register { AppDelegate() }.resolvingProperties { (container, delegate) in
                delegate.mainRouter = try container.resolve()
        }
        #endif
        
        container.register { MainLaunchRouter(window: $0, storyboard: storyboards.initialStoryboard) as LaunchRouter }
        
        container.register { AppDelegateProxy() }
            .resolvingProperties { (_, proxy) in
                proxy.handlers = [
                    self.appDelegate
                ]
        }
    }
}
// swiftlint:enable delegate
