//
//  ViewController.swift
//  ProductsList
//
//  Created by Bondar Yaroslav on 11/15/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
}

import Foundation

enum URLs {
    
    private static let basePath = "https://s3-eu-west-1.amazonaws.com/developer-application-test/"
    
    enum Products {
        private static let base = "cart/"
        
        static let all = base + "list/"
        
        static func detail(id: Int) -> String {
            return base + "{\(id)}/detail"
        }
    }
    
}
