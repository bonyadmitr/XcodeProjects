//
//  ViewController.swift
//  VKSwiftyTest
//
//  Created by Bondar Yaroslav on 05/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyVK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func actionLoginButton(_ sender: UIButton) {
        _ = firstly {
            VKManager.shared.login()
        }.then { _ -> Promise<String> in
            VKManager.shared.getUser()
        }.then { json -> Void in
            print(json)
        }
    }
    
    @IBAction func actionShareButton(_ sender: UIButton) {
        guard let id = VKAuthorizeResult.userId else { return }
        //"counters"
        let fields = "id,first_name,last_name,sex,bdate,city,country,photo_50,photo_100,photo_200_orig,photo_200,photo_400_orig,photo_max,photo_max_orig,online,online_mobile,lists,domain,has_mobile,contacts,connections,site,education,universities,schools,can_post,can_see_all_posts,can_see_audio,can_write_private_message,status,last_seen,common_count,relation,relatives,counters"
        VK.API.Users.get([.userId: id, .fields: fields]).send(
            onSuccess: { response in
                print(response)
        }, onError: { error in
            print(error)
        })
    }
}
