//
//  ProfileController.swift
//  GenericTableViewController
//
//  Created by zdaecqze zdaecq on 03.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ProfileController: UIViewController {
    
    var person: String = ""
    var didTapClose: () -> () = {}
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        didTapClose()
    }
}
