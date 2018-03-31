//
//  ViewController.swift
//  SegmentedColControl
//
//  Created by Yaroslav Bondar on 28.03.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: SegmentedColControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.images = [#imageLiteral(resourceName: "flat_gray"), #imageLiteral(resourceName: "happy_gray"), #imageLiteral(resourceName: "sad_gray")]
//        segmentedControl.animationTime = 1
//        segmentedControl.selectingAnimationType = .basic
//        segmentedControl.cellHeight = .imageWith(20)
//        segmentedControl.selectingViewSize = .inset(dx: 20, dy: 0)
//        segmentedControl.selectingViewColor = #colorLiteral(red: 0.2387923024, green: 0.8305857259, blue: 0.8970016826, alpha: 0.8025143046)
        
    }
    @IBAction func actionSegmentedController(_ sender: SegmentedColControl) {
        print(sender.selectedIndex)
    }
}
