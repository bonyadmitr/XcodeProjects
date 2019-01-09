//
//  ViewController.swift
//  ActivityViewController
//
//  Created by Bondar Yaroslav on 1/9/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showActivityVC()
        }
    }
    
    @IBAction private func showActivity(_ sender: UIButton) {
        showActivityVC()
    }

    private func showActivityVC() {
        /// abstract class
        //let activity = UIActivity()
        
        let objectsToShare = ["Some text"]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [
            .airDrop, .openInIBooks, .saveToCameraRoll, .assignToContact,
            .copyToPasteboard,
            /// does not work in iOS 9.3, working in iOS 10.3 and 11
            /// https://stackoverflow.com/a/39710905/5893286
            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
            UIActivity.ActivityType(rawValue: "com.google.Drive.ShareExtension")
        ]
        
        present(activityVC, animated: true, completion: nil)
    }
}

