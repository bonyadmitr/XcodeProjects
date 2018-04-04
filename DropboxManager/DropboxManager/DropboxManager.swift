//
//  DropboxManager.swift
//  DropboxSdk
//
//  Created by Bondar Yaroslav on 4/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import ObjectiveDropboxOfficial

///https://github.com/dropbox/dropbox-sdk-obj-c

/// connected alamofire inside
///https://github.com/dropbox/SwiftyDropbox

/// Info.plist
//<key>LSApplicationQueriesSchemes</key>
//<array>
//<string>dbapi-2</string>
//<string>dbapi-8-emm</string>
//</array>
//
//<key>CFBundleURLTypes</key>
//<array>
//<dict>
//<key>CFBundleTypeRole</key>
//<string>Editor</string>
//<key>CFBundleURLSchemes</key>
//<array>
//<string>db-2ettjg3gh8318zt</string>
//</array>
//</dict>
//</array>

enum DropboxManagerResult {
    /// User is logged into Dropbox
    case success(token: String)
    /// Authorization flow was manually canceled by user!
    case cancel
    /// some error from sdk
    case failed(String)
}

typealias DropboxLoginHandler = (DropboxManagerResult) -> Void

final class DropboxManager {
    
    static let shared = DropboxManager()
    
    private var handler: DropboxLoginHandler?
    
    private var token: String? {
        return DBOAuthManager.shared()?.retrieveFirstAccessToken()?.accessToken
    }
    
    func prepareForUse(with appKey: String) {
        DBClientsManager.setup(withAppKey: appKey)
    }
    
    func handleRedirect(url: URL) -> Bool {
        
        guard let dbResult = DBClientsManager.handleRedirectURL(url) else {
            return false
        }
        
        if dbResult.isSuccess() {
            handler?(.success(token: dbResult.accessToken.accessToken))
        } else if dbResult.isCancel() {
            handler?(.cancel)
        } else if dbResult.isError() {
            handler?(.failed(dbResult.description()))
        }
        
        return true
    }
    
    func loginIfNeed(handler: @escaping DropboxLoginHandler) {
        if let token = token {
            handler(.success(token: token))
            return
        }
        login(handler: handler)
    }
    
    func login(handler: @escaping DropboxLoginHandler) {
        self.handler = handler
        guard let vc = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
            return
        }
        DBClientsManager.authorize(fromController: UIApplication.shared, controller: vc) { url in
            UIApplication.shared.openURL(url)
        }
    }
    
    func logout() {
        DBOAuthManager.shared()?.clearStoredAccessTokens()
    }
}
