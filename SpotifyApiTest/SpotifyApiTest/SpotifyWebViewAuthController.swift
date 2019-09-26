import WebKit

protocol SpotifyWebViewAuthControllerDelegate: class {
    func spotifyAuthSuccess(with spotifyCode: String)
    func spotifyAuthCancel()
}

final class SpotifyWebViewAuthController: UIViewController {
    
    private let webView = WKWebView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        //let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = view.bounds
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return activityIndicator
    }()
    
    weak var delegate: SpotifyWebViewAuthControllerDelegate?
    
    deinit {
        webView.navigationDelegate = nil
        webView.stopLoading()
    }
    
    override func loadView() {
        view = webView
        webView.navigationDelegate = self
        title = "Spotify login"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        removeCache()
        
        let clientID = "8ea6ec9161534d84be983e780390a6a7"
        
        let redirectUrl = "spotifytest://spotify-login-callback"
        assert(redirectUrl == redirectUrl.lowercased(), "don't use CAPITAL letters in custom urls. it will be need in urls comparison")
        
        guard let url = URL(string: "https://accounts.spotify.com/authorize?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectUrl)&scope=playlist-read-private") else {
            assertionFailure()
            return
        }
        
        loadWebView(with: url)
        startActivity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            delegate?.spotifyAuthCancel()
        }
    }
    
    func loadWebView(with url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func removeCache() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            
            // TODO: needs to check
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

extension SpotifyWebViewAuthController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivity()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopActivity()
        //delegate?.spotifyAuthCancel()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let webPageUrl = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        guard let scheme = webPageUrl.scheme, let host = webPageUrl.host else {
            decisionHandler(.allow)
            return
        }
        
        let currentUrl = "\(scheme)://\(host)"
        let redirectUrl = "spotifytest://spotify-login-callback"
        
        guard
            currentUrl == redirectUrl,
            let queryItems = URLComponents(string: webPageUrl.absoluteString)?.queryItems,
            let spotifyCode = queryItems.first(where: { $0.name == "code" })?.value
        else {
            decisionHandler(.allow)
            return
        }
        
        //removeCache()
        
        /// can be .allow but we don't need loads somthing else
        decisionHandler(.cancel)
        
        delegate?.spotifyAuthSuccess(with: spotifyCode)
    }
}
