//
//  VKManager.swift
//  VKSwiftyTest
//
//  Created by Bondar Yaroslav on 05/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import SwiftyVK
import PromiseKit
import UIKit

class VKManager {
    static let shared = VKManager()
    
    static let appID = "5968064"
    static var appUrl: String {
        return "vk" + appID
    }
    let scope: Set<VK.Scope> = [.wall,.photos]
    
    fileprivate let (authorizePromise, authorizeFulfill, authorizeReject) = Promise<Void>.pending()
    
    func login() -> Promise<Void> {
        VK.logIn()
        return authorizePromise
    }
    
    func getUser() -> Promise<String> {
        return Promise(resolvers: { (fulfill, reject) in
            VK.API.Users.get().send(onSuccess: { json in
                fulfill(json.stringValue)
            }, onError: { error in
                reject(error)
            }, onProgress: { (done, total) in
                print(done/total)
            })
        })
    }
}

extension VKManager: VKDelegate {
    
    public func vkWillAuthorize() -> Set<SwiftyVK.VK.Scope> {
        return scope
    }
    
    ///Called when SwiftyVK did authorize and receive token
    public func vkDidAuthorizeWith(parameters: [String : String]) {
        authorizeFulfill()
        guard let result = VKAuthorizeResult(json: parameters) else { return }
        VKAuthorizeResult.userId = result.userId
    }
    
    ///Called when SwiftyVK did unauthorize and remove token
    public func vkDidUnauthorize() {
        print("--- vkDidUnauthorize")
    }
    
    ///Called when SwiftyVK did failed autorization
    public func vkAutorizationFailedWith(error: SwiftyVK.AuthError) {
        authorizeReject(error)
        print("--- vkAutorizationFailedWith", error.localizedDescription)
        print(error.errorUserInfo)
    }
    
    public func vkShouldUseTokenPath() -> String? {
        return nil
    }
    
    public func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
}
