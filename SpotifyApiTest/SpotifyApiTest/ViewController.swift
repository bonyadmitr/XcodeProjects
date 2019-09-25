//
//  ViewController.swift
//  SpotifyApiTest
//
//  Created by Bondar Yaroslav on 9/25/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

final class SpotifySDKManager: NSObject {
    
    static let shared = SpotifySDKManager()
    
    /// get from https://developer.spotify.com/dashboard/applications
    private let clientID = "8ea6ec9161534d84be983e780390a6a7"
    
    private let redirectUrl: URL = {
        if let url = URL(string: "spotifyTest://spotify-login-callback") {
            return url
        } else {
            assertionFailure()
            return URL(fileURLWithPath: "")
        }
    }()
    
    private lazy var sessionManager: SPTSessionManager = {
        let configuration = SPTConfiguration(clientID: clientID, redirectURL: redirectUrl)
        return SPTSessionManager(configuration: configuration, delegate: self)
    }()
    
    func connectToSporify() {
        sessionManager.isSpotifyAppInstalled ? connectToSpotifyWithSDK() : ()//showSpotifyAuthWebViewController()
    }
    
    private func connectToSpotifyWithSDK() {
        let scope: SPTScope = [.playlistReadPrivate, .userLibraryRead]
        
        if #available(iOS 11, *) {
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        } else if let controller = UIApplication.shared.keyWindow?.rootViewController {
            sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: controller)
        } else {
            assertionFailure("should be never called")
        }
    }
    
    func handleRedirectUrl(url: URL) -> Bool {
        // TODO: check redirect url (spotifyTest://spotify-login-callback)
        
        guard let urlComponents = URLComponents(string: url.absoluteString) else {
            assertionFailure()
            return false
        }
        
        if let code = urlComponents.queryItems?.first(where: { $0.name == "code"})?.value {
            print("success with code: \(code)")
        } else {
            assertionFailure("should be never called")
//            delegate?.showSpotifyAuthWebViewController()
        }
        return true
    }
}

extension SpotifySDKManager: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        /// nothing to do
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        //showSpotifyAuthWebViewController()
    }
}
