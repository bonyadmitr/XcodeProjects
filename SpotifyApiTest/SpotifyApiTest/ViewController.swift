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


import UIKit
import WebKit

protocol SpotifyAuthViewControllerDelegate: class {
    func spotifyAuthSuccess(with code: String)
    func spotifyAuthCancel()
}

final class SpotifyAuthViewController: UIViewController {
    
    private let webView = WKWebView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = view.bounds
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return activityIndicator
    }()
    
    weak var delegate: SpotifyAuthViewControllerDelegate?
    
    deinit {
        webView.navigationDelegate = nil
        webView.stopLoading()
    }
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
        title = "Spotify login"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        showSpinner()
        view.addSubview(activityIndicator)
        removeCache()
        startActivity()
    }
    
    func loadWebView(with url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func handleBackButton() {
        if isMovingFromParent {
            delegate?.spotifyAuthCancel()
        }
    }

    private func removeCache() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            
            // TODO: need to check
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                 for: records,
                                 completionHandler: {})
            
            // old logic
//            records.forEach({ record in
//                dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
//                                     for: [record],
//                                     completionHandler: {})
//            })
        }
    }
    
    private func startActivity() {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
    }
    
    private func stopActivity() {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
    }
}

extension SpotifyAuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivity()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopActivity()
        delegate?.spotifyAuthCancel()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let currentUrl = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        guard let queryItems = URLComponents(string: currentUrl.absoluteString)?.queryItems else {
            assertionFailure()
            return
        }
        
        if let spotifyCode = queryItems.first(where: { $0.name == "code"})?.value {
            print("success with code: \(spotifyCode)")
            
            delegate?.spotifyAuthSuccess(with: spotifyCode)
            removeCache()
            
            decisionHandler(.cancel)
        } else {
            assertionFailure("should be never called")
            decisionHandler(.allow)
        }
    }
}
