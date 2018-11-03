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
    
    /// #1
    private var userWebContentController: WKUserContentController {
        let contentController = WKUserContentController()
        //let scriptSource = "document.body.style.color = 'white'; document.body.style.webkitTextSizeAdjust = 'auto';"
        let scriptSource = "document.body.style.webkitTextSizeAdjust = 'auto';"
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        return contentController
    }
    
    private var webViewConfiguration: WKWebViewConfiguration {
        let webConfig = WKWebViewConfiguration()
        webConfig.userContentController = userWebContentController
        if #available(iOS 10.0, *) {
            webConfig.dataDetectorTypes = [.phoneNumber, .link]
        }
        return webConfig
    }
    
    private lazy var webView: WKWebView = {
        let web = WKWebView(frame: .zero, configuration: webViewConfiguration)
        web.isOpaque = false
        /// fixing push bug when backgroundColor = .clear (can be set to controller's view)
//        web.backgroundColor = .white
        //web.scrollView.backgroundColor = .white
        web.navigationDelegate = self
        web.frame = view.bounds
        web.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return web
    }()

    /// #2    
//    private lazy var webView: WKWebView = {
//        let contentController = WKUserContentController()
//        let scriptSource = "document.body.style.webkitTextSizeAdjust = 'auto';"
//        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        contentController.addUserScript(script)
//        
//        let webConfig = WKWebViewConfiguration()
//        webConfig.userContentController = contentController
//        if #available(iOS 10.0, *) {
//            webConfig.dataDetectorTypes = [.phoneNumber, .link]
//        }
//        
//        let web = WKWebView(frame: .zero, configuration: webConfig)
        /// fixing push bug when backgroundColor = .clear (can be set to controller's view)
        //web.backgroundColor = .white
//        web.navigationDelegate = self
//        return web
//    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        title = "Privacy Policy".localized /// Terms and Privacy Policy
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
        
//        edgesForExtendedLayout = [.bottom]
//        edgesForExtendedLayout = []
//        extendedLayoutIncludesOpaqueBars = false
    }
    
    
//    override func loadView() {
//        view = webView
//    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.frame = view.bounds
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if #available(iOS 11.0, *) {
////            webView.scrollView.contentInsetAdjustmentBehavior = .never
////            webView.scrollView.insetsLayoutMarginsFromSafeArea = false //.bottom = 0
////            webView.scrollView.safe
//            additionalSafeAreaInsets.bottom = -49
//        } else {
//            // Fallback on earlier versions
//        }
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
//        webView.clearPage()
        
        /// don't need
//        automaticallyAdjustsScrollViewInsets = false
        
        guard let url = URL(string: "https://termsfeed.com/privacy-policy/da1b66dee2c0e974d68d1d47e787bbf2") else {
            assertionFailure()
            return
        }
        webView.load(URLRequest(url: url))
        //webView.loadHTMLString(eulaHTML, baseURL: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //start activity indicator
        
        /// for local files
        //webView.loadFileURL(url, allowingReadAccessTo: url)
    }
    
    deinit {
        webView.navigationDelegate = nil
        webView.stopLoading()
    }
}
extension PrivacyPolicyController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == (identifierComponents.last as? String), "unexpected restoration path: \(identifierComponents)")
        return PrivacyPolicyController(coder: coder)
    }
}
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
        
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
        
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
