//
//  ViewController.swift
//  AnimatablePopup
//
//  Created by Bondar Yaroslav on 3/22/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var popupView: PopupView!
    
    @IBAction func actionPopupButton(_ sender: UIButton) {
        popupView.show(in: view)
    }
}
