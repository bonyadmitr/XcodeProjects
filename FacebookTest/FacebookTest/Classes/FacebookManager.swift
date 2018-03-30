//
//  FacebookManager.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import FacebookCore
import FacebookLogin
import PromiseKit

enum FacebookErrors: Error {
    case failed(NSError)
    case cancelled
    
    var localizedDescription: String {
        switch self {
        case .failed(let err):
            /// need to login
            if let message = err.userInfo["com.facebook.sdk:FBSDKErrorDeveloperMessageKey"] as? String {
                return message
            }
            return err.userInfo.description
        case .cancelled:
            return "cancelled"
        }
    }
}

extension Permission {
    static let publicProfile = Permission(name: "publish_actions")
}

final class FacebookManager {
    
    static let shared = FacebookManager()
    
    private let fbLoginManager = LoginManager()
    
    var isEnablePublishActions: Bool {
        if let result = AccessToken.current?.grantedPermissions?.contains(Permission.publicProfile), result == true {
            return true
        }
        return false
    }
    
    func login() -> Promise<Void> {
        return Promise(resolvers: { (fulfill, resject) in
            fbLoginManager.logIn([.publicProfile, .email], viewController: nil) { result in
                switch result {
                case .failed(let error):
                    resject(FacebookErrors.failed(error as NSError))
                case .cancelled:
                    resject(FacebookErrors.cancelled)
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print(grantedPermissions)
                    print(declinedPermissions)
                    print(accessToken)
                    print("Logged in!")
                    fulfill()
                }
            }
        })
    }
    
    func loginForPublishActions() -> Promise<Void> {
        return Promise(resolvers: { (fulfill, resject) in
            fbLoginManager.logIn([.publishActions], viewController: nil) { result in
                switch result {
                case .failed(let error):
                    resject(FacebookErrors.failed(error as NSError))
                case .cancelled:
                    resject(FacebookErrors.cancelled)
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print(grantedPermissions)
                    print(declinedPermissions)
                    print(accessToken)
                    print("Logged in!")
                    fulfill()
                }
            }
        })
    }
    
    func getUser() -> Promise<User> {
        return Promise(resolvers: { (fulfill, resject) in
            let connection = GraphRequestConnection()
            connection.add(MyProfileRequest()) { response, result in
                switch result {
                case .success(let response):
                    fulfill(response)
                case .failed(let error):
                    resject(FacebookErrors.failed(error as NSError))
//                    resject(error)
                }
            }
            connection.start()
        })
    }
    
    func getUserWithLogin() -> Promise<User> {
        return firstly {
            FacebookManager.shared.login()
        }.then {
            FacebookManager.shared.getUser()
        }
    }
    
    func publish(handler: @escaping () -> Void) {
        if FacebookManager.shared.isEnablePublishActions {
            handler()
        } else {
            _ = firstly {
                FacebookManager.shared.loginForPublishActions()
            }.then {
                handler()
            }
        }
    }
    
//    func postSome() {
//        if FBSDKAccessToken.current() == nil {
//            return print("FBSDKAccessToken == nil")
//        }
//        if !FBSDKAccessToken.current().hasGranted("publish_actions") {
//            return print("FBSDKAccessToken not hasGranted")
//        }
//        let params = ["fields": "name, email, picture.type(noraml)"]
//        FBSDKGraphRequest(graphPath: "me/feed", parameters: params).start { (connection, result, error) in
//            if let error = error {
//                return print("FBSDKGraphRequest error:", error.localizedDescription)
//            }
//            print(result!)
//            
//        }
//    }
}
