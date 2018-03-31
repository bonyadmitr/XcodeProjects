//
//  ViperController.swift
//  ViperKit
//
//  Created by Bondar Yaroslav on 27/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

open class ViperController: UIViewController, ModuleInputProvider {
    
    open var moduleInput: ModuleInput!
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let configurationBlock = sender as? ConfigurationBlockHolder else {
            return
        }
        
        let potentialModuleInputProvider: UIViewController
        
        if segue.destination is ModuleInputProvider {
            potentialModuleInputProvider = segue.destination
        } else if let destination = segue.destination as? UINavigationController {
            guard let top = destination.topViewController else {
                fatalError("Pushing empty navigation controller not allowed")
            }
            potentialModuleInputProvider = top
        } else if let destination = segue.destination as? UITabBarController {
            guard let def = destination.selectedViewController else {
                fatalError("Pushing empty tab bar controller not allowed")
            }
            potentialModuleInputProvider = def
        } else {
            fatalError("Module input provider not found")
        }
        
        guard let controller = potentialModuleInputProvider as? ModuleInputProvider else {
            fatalError("Controller should be Module Input provider")
        }
        
        configurationBlock.block(controller.moduleInput)
    }
}

extension ViperController: TransitionHandler {
    open func openModule(segueIdentifier: String) {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    open func openModule(segueIdentifier: String, configurationBlock: @escaping ConfigurationBlock) {
        performSegue(withIdentifier: segueIdentifier, sender: ConfigurationBlockHolder(block: configurationBlock))
    }
    
    open func closeCurrentModule() {
        guard let navVC = parent as? UINavigationController else {
            return dismiss(animated: true, completion: nil)
        }
        
        if navVC.viewControllers.count > 1 {
            navVC.popViewController(animated: true)
        } else {
            navVC.dismiss(animated: true, completion: nil)
        }
    }
}
