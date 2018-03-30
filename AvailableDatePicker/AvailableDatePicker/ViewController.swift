//
//  ViewController.swift
//  AvailableDatePicker
//
//  Created by Bondar Yaroslav on 02/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var availableDatePicker: AvailableDatePicker!
    
    @IBAction func actionDoneBarButton(_ sender: Any) {
        UIAlertView(title: String(describing: availableDatePicker.selectedDate), message: nil, delegate: nil, cancelButtonTitle: "Ok").show()
        print("-----", availableDatePicker.selectedDate ?? "nil")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        availableDatePicker.dates = [
            Date(),
            Date(timeIntervalSince1970: 50000),
            Date(timeIntervalSince1970: 100000),
            Date(timeIntervalSince1970: 200000),
            Date(timeIntervalSince1970: 500000),
            Date(timeIntervalSince1970: 1000),
            Date(timeIntervalSince1970: 100000000),
            Date(timeIntervalSince1970: 10000000),
            Date(timeIntervalSince1970: 1000000000),
            Date(timeIntervalSince1970: 1005000000),
            Date(timeIntervalSince1970: 1000050000),
            Date(timeIntervalSince1970: 1000550000),
            Date(timeIntervalSince1970: 2000000000),
            Date(timeIntervalSince1970: 10000000000),
            Date(timeIntervalSince1970: 5000000000)
        ]
        
        availableDatePicker.textColor = UIColor.white
        availableDatePicker.textFont = UIFont(name: "HelveticaNeue-Light", size: 21)!
        availableDatePicker.rowInset = 10
//        availableDatePicker.startDate = Date(timeIntervalSince1970: 1000550000)
    }
}
