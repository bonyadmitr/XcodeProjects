//
//  ViewController.swift
//  NextTextField
//
//  Created by Bondar Yaroslav on 10/3/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func actionDoneButton(_ sender: UIButton) {
        let vc = UIAlertController(title: "Alert", message: "From button", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        vc.addAction(okAction)
        present(vc, animated: true, completion: nil)
    }
}

