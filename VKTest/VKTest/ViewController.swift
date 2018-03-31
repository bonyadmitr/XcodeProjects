//
//  ViewController.swift
//  VKTest
//
//  Created by Bondar Yaroslav on 04/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import VKSdkFramework
import PromiseKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func actionLoginButton(_ sender: UIButton) {
        _ = firstly {
            VKManager.shared.login()
        }.then { _ -> Void in
            //print(VKSdk.accessToken().userId) //44989811
            print("login finished")
        }
    }
    
    @IBAction func actionShareButton(_ sender: UIButton) {
        
        _ = firstly {
            VKManager.shared.createPost(with: "Hello VK API")
        }.then { _ -> Void in
            print("sended")
        }
        
        /// get user
        /// it is also in VKSdk.accessToken().localUser
        
//        _ = firstly {
//            VKManager.shared.getUser()
//        }.then { user -> Void in
//            print(user)
//        }
        
        /// Share Dialog
        
//        let shareDialog = VKShareDialogController()
//        shareDialog.text = "This post created using #vksdk #ios"
//        //shareDialog.vkImages = ["-10889156_348122347", "7840938_319411365", "-60479154_333497085"]
//        shareDialog.shareLink = VKShareLink(title: "Super puper link, but nobody knows", link: URL(string: "https://vk.com/dev/ios_sdk"))
//        shareDialog.completionHandler = { result in
//            self.dismiss(animated: true, completion: nil)
//        }
//        present(shareDialog, animated: true, completion: nil)
        
        
        /// Share Activity
        
//        let items: [Any] = ["Check out information about VK SDK",
//                            URL(string: "https://vk.com/dev/ios_sdk")!]
//        
//        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: [VKActivity()])
//        activityViewController.setValue("VK SDK", forKey: "subject")
//        //activityViewController.completionWithItemsHandler
//        let popover = activityViewController.popoverPresentationController
//        popover?.sourceView = view
//        popover?.sourceRect = sender.frame
//        
//        present(activityViewController, animated: true, completion: nil)

    }
}

