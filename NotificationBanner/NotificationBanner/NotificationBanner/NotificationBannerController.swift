//
//  NotificationBannerController.swift
//  NotificationBanner
//
//  Created by zdaecqze zdaecq on 13.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class NotificationBannerController: UIViewController {
    
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var didPressBanner: () -> () = {}
    var didPressHideButton: () -> () = {}
    
    @IBAction func actionBunner(sender: UIButton) {
        didPressBanner()
    }
    @IBAction func hideBanner(sender: UIButton) {
        didPressHideButton()
    }
}
