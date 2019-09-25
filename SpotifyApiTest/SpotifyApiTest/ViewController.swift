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

import UIKit
import WebKit

protocol SpotifyAuthViewControllerDelegate: class {
    func spotifyAuthSuccess(with code: String)
    func spotifyAuthCancel()
}

final class SpotifyAuthViewController: UIViewController {
    
    private let webView = WKWebView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        //let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        let activityIndicator = UIActivityIndicatorView(style: .large)
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
