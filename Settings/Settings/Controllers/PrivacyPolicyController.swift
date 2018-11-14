//
//  PrivacyPolicyController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 10/11/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import WebKit

final class PrivacyPolicyController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        let scriptSource = "document.body.style.webkitTextSizeAdjust = 'auto';"
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        
        let webConfig = WKWebViewConfiguration()
        webConfig.userContentController = contentController
        if #available(iOS 10.0, *) {
            webConfig.dataDetectorTypes = [.phoneNumber, .link]
        }
        
        let webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.isOpaque = false
        webView.navigationDelegate = self
        
        /// there is a bug for iOS 9
        /// https://stackoverflow.com/a/32843700/5893286
        webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        return webView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = view.bounds
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return activityIndicator
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        title = L10n.privacyPolicy
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
    }
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        webView.frame = view.bounds
//        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(webView)
        
        view.addSubview(activityIndicator)
        
        //webView.clearPage()
        
        guard let url = URL(string: "https://termsfeed.com/privacy-policy/da1b66dee2c0e974d68d1d47e787bbf2") else {
            assertionFailure()
            return
        }
        webView.load(URLRequest(url: url))
        //webView.loadHTMLString(eulaHTML, baseURL: nil)
        
        /// for local files
        //webView.loadFileURL(url, allowingReadAccessTo: url)
        
        startActivity()
    }
    
    deinit {
        webView.navigationDelegate = nil
        webView.stopLoading()
    }
    
    private func startActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
    }
    
    private func stopActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
    }
}

// MARK: - UIViewControllerRestoration
extension PrivacyPolicyController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == identifierComponents.last, "unexpected restoration path: \(identifierComponents)")
        return PrivacyPolicyController(coder: coder)
    }
}

// MARK: - WKNavigationDelegate
extension PrivacyPolicyController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        /// #1
//        guard let currentUrl = navigationAction.request.url?.absoluteString else {
//            decisionHandler(.cancel)
//            return
//        }
//        
//        //        if currentUrl.contains("#access_token"), navigationAction.navigationType == .formSubmitted {
//        //            isLoginStarted = true
//        //        } else if currentUrl.contains("access_denied"), navigationAction.navigationType == .formSubmitted {
//        //            isLoginCanceled = true
//        //        }
//        
//        decisionHandler(.allow)
        
        /// #2
        switch navigationAction.navigationType {
        case .linkActivated:
//            UIApplication.shared.openSafely(navigationAction.request.url)
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivity()
        
//        if #available(iOS 11.0, *) {
//            print("-- safeAreaInsets", webView.scrollView.safeAreaInsets)
//        } else {
//            /// need for iOS 10. don't need for iOS 11 (contentInset == .zero)
//            /// https://stackoverflow.com/a/35345720/5893286
//            webView.scrollView.contentInset.bottom = 0
//    //        webView.scrollView.contentInset = .zero
//        } 
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopActivity()
        
//        webView.scrollView.contentInset.bottom = 0
//        showErrorAlert(message: error.description)
    }
//    
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        output.didStartLoad()
//    }
}

import Foundation
import WebKit

extension WKWebView {
    
    func clearPage() {
        guard let url = URL(string: "about:blank") else {
            return
        }
        load(URLRequest(url: url))
    }
    
    var doubleTapZoomGesture: UITapGestureRecognizer? {
        for view in scrollView.subviews {
            guard String(describing: view.classForCoder) == "UIWebBrowserView",
                let gestures = view.gestureRecognizers
                else { continue }
            
            for gesture in gestures {
                if let gesture = gesture as? UITapGestureRecognizer, gesture.numberOfTapsRequired == 2 {
                    return gesture
                }
            }
        }
        return nil
    }
}
