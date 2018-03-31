//
//  VKManager.swift
//  VKTest
//
//  Created by Bondar Yaroslav on 04/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import VKSdkFramework
import PromiseKit

enum VKCustomErrors: Error {
    case unknown
    case authorizationFailed
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "unknow error"
        case .authorizationFailed:
            return "Authorization failed"
        }
    }
}

final class VKManager: NSObject {
    
    static let shared = VKManager()
    static let appID = "5965361"
    static var appUrl: String {
        return "vk" + appID
    }
    
    func start() {
        let sdkInstance = VKSdk.initialize(withAppId: VKManager.appID)!
        sdkInstance.register(VKManager.shared)
        sdkInstance.uiDelegate = VKManager.shared
        VKSdk.wakeUpSession(VKManager.shared.loginScope, complete: { (_, _) in })
    }
    
    lazy var loginScope = [VK_PER_WALL]
    //["photos", "friends", "audio", "status"]
    //VK_PER_NOTIFY, VK_PER_FRIENDS, VK_PER_PHOTOS, VK_PER_AUDIO, VK_PER_VIDEO, VK_PER_DOCS, VK_PER_NOTES, VK_PER_PAGES, VK_PER_STATUS, VK_PER_WALL, VK_PER_GROUPS, VK_PER_MESSAGES, VK_PER_NOTIFICATIONS, VK_PER_STATS, VK_PER_ADS, VK_PER_OFFLINE, VK_PER_NOHTTPS, VK_PER_MARKET, VK_PER_EMAIL
    
    fileprivate let (authorizePromise, authorizeFulfill, authorizeReject) = Promise<Void>.pending()
    
    func login() -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            VKSdk.wakeUpSession(loginScope) { (state, error) in
                if state == .authorized {
                    fulfill()
                } else if let error = error {
                    reject(error)
                } else {
                    VKSdk.authorize(self.loginScope)
                    _ = self.authorizePromise.then {
                        fulfill()
                    }.catch { error in
                        reject(error)
                    }
                }
            }
        })
    }
    
    func getUser() -> Promise<VKUser> {
        return Promise(resolvers: { (fulfill, reject) in
            if VKSdk.accessToken() != nil {
                let params = [VK_API_FIELDS: "id,first_name,last_name,sex,bdate,city,country,photo_50,photo_100,photo_200_orig,photo_200,photo_400_orig,photo_max,photo_max_orig,online,online_mobile,lists,domain,has_mobile,contacts,connections,site,education,universities,schools,can_post,can_see_all_posts,can_see_audio,can_write_private_message,status,last_seen,common_count,relation,relatives,counters"]
                VKApi.users().get(params).execute(resultBlock: { (responce) in
                    guard let user = (responce?.parsedModel as? VKUsersArray)?.firstObject() else {
                        return reject(VKCustomErrors.unknown)
                    }
                    fulfill(user)
                    
                }, errorBlock: { error in
                    if let error = error {
                        reject(error)
                    } else {
                        reject(VKCustomErrors.unknown)
                    }
                })
                
//            print(VKSdk.accessToken().accessToken)
//            print(VKSdk.accessToken().userId)

//            VK_API_OWNER_ID
//            VK_API_ACCESS_TOKEN
//            VK_API_USER_ID
//            VK_API_MESSAGE
//            VKApi.wall()
//            VKRequest(method: <#T##String!#>, parameters: <#T##[AnyHashable : Any]!#>)
            }
        })
    }
    
    func createPost(with text: String) -> Promise<Void> {
        /// owner_id == current user id is used by default
        let params = ["message": text]
        return Promise(resolvers: { (fulfill, reject) in
            VKRequest(method: "wall.post", parameters: params).execute(resultBlock: { responce in
                print(responce?.json ?? "nil")
                fulfill()
            }, errorBlock: { error in
                if let error = error {
                    reject(error)
                } else {
                    reject(VKCustomErrors.unknown)
                }
            })
        })
    }
    
}

extension VKManager: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("--- vkSdkAccessAuthorizationFinished")
        print("state", result.state)
        if result.error != nil {
            authorizeReject(result.error)
        } else if result.token != nil {
            authorizeFulfill()
        }
    }
    func vkSdkUserAuthorizationFailed() {
        print("--- vkSdkUserAuthorizationFailed")
        authorizeReject(VKCustomErrors.unknown)
    }
}

extension VKManager: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("--- vkSdkShouldPresent")
        guard let vc = UIApplication.topViewController() else {
            return
        }
        vc.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        guard let vc = UIApplication.topViewController(),
            let captchaVC = VKCaptchaViewController.captchaControllerWithError(captchaError) else {
            return
        }
        captchaVC.present(in: vc)
        print("--- vkSdkNeedCaptchaEnter", captchaError)
    }
}
