//
//  ViewController.swift
//  SideMenu1
//
//  Created by Bondar Yaroslav on 29/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import SWRevealViewController

class RevealViewController: SWRevealViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //http://www.ebc.cat/2015/03/07/customize-your-swrevealviewcontroller-slide-out-menu/
        
        
//        rearViewRevealWidth = 150
//        rearViewRevealOverdraw = 20
        rearViewRevealDisplacement = 0
//        bounceBackOnOverdraw = false
    }
}

class ViewController: UITableViewController {

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
    }
}

