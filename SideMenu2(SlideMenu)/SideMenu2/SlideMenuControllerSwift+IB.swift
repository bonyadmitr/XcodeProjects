//
//  SlideMenuControllerSwift+IB.swift
//  SideMenu2
//
//  Created by Yaroslav Bondar on 30.01.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {
    
    override func awakeFromNib() {
        performSegue(withIdentifier: "main", sender: nil)
        performSegue(withIdentifier: "left", sender: nil)
        super.awakeFromNib()
    }
}

class SetMenuSegue: UIStoryboardSegue {
    override func perform() {
        
        guard let slideMenuController = source as? SlideMenuController else {
            fatalError("container is not SlideMenuController subclass")
        }
        if identifier == "main" {
            slideMenuController.mainViewController = destination
        } else if identifier == "left" {
            slideMenuController.leftViewController = destination
        } else {
            fatalError("segue identifier is not 'main' or 'left'")
        }
    }
}

class PushMenuSegue: UIStoryboardSegue {
    override func perform() {
        source.slideMenuController()!.changeMainViewController(destination, close: true)
    }
}

extension UIViewController {
    @IBAction func toggleLeftMenu(_ sender: Any) {
        slideMenuController()?.toggleLeft()
    }
}
