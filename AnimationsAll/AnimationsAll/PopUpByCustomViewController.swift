//
//  PopUpByCustomViewController.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 27.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class PopUpByCustomClassController: UIViewController {
    
    @IBOutlet var popUpView: PopUpView!
    
    //button in controller
    @IBAction func showButton(_ sender: UIButton) {
        popUpView.show(in: navigationController?.view ?? view)
    }
    
    //button in popUpView
    @IBAction func hideButton(_ sender: UIButton) {
        popUpView.hidePopUp()
    }
}
