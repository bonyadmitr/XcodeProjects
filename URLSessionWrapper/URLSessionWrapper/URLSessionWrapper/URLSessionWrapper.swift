//
//  URLSessionWrapper.swift
//  URLSessionWrapper
//
//  Created by Bondar Yaroslav on 6/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

// TODO: request with completion json
//        let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
// TODO: error handling

private let NSURLResponseUnknownLength = -1

typealias HTTPheaders = [String: String]
typealias HTTPParameters = [String: String]
typealias ResponseValidator = (HTTPURLResponse) -> Bool

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case head = "HEAD"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

typealias ProgressHandler = ((Progress) -> Void)
typealias PercentageHandler = (Double) -> Void

// MARK: - class
final class URLSessionWrapper: NSObject {
    
    static let shared = URLSessionWrapper()
    
    var backgroundCompletionHandler: (() -> Void)?
    
    /// https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW2
    /// Because only one process can use a background session at a time, you need to create a different background session for the containing app and each of its app extensions. (Each background session should have a unique identifier.) It’s recommended that your containing app only use a background session that was created by one of its extensions when the app is launched in the background to handle events for that extension. If you need to perform other network-related tasks in your containing app, create different URL sessions for them.
    private lazy var urlSession: URLSession = {
        /// Completion handler blocks are not supported in background sessions
        /// https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_in_the_background
        let config = URLSessionConfiguration.background(withIdentifier: "MySession")
//        let config = URLSessionConfiguration.default
        
        config.allowsCellularAccess = true /// default true, check false
        config.httpCookieAcceptPolicy = .onlyFromMainDocumentDomain /// default
        config.httpAdditionalHeaders = URLSessionWrapper.defaultHTTPHeaders
        config.requestCachePolicy = .useProtocolCachePolicy /// default
        config.timeoutIntervalForRequest = 30 /// default 60
        
        /// for background sessions
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        
        /// To access the shared container you set up, use the sharedContainerIdentifier property on your configuration object.
        //config.sharedContainerIdentifier = "com.mycompany.myappgroupidentifier"
        
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    
    var tasks: [GenericTask] = []
    
    func request(_ path: URLConvertible,
                 method: HTTPMethod = .get,
                 headers: HTTPheaders? = nil,
                 parameters: HTTPParameters? = nil,
                 validator: ResponseValidator? = defaultValidator,
                 percentageHandler: PercentageHandler? = nil,
                 completion: @escaping DataResult) {
        
        let url: URL
        
        do {
            url = try path.asURL()
        } catch {
            
            /// add DEVELOP
//            #if DEBUG
//            fatalError("invalid url")
//            #else
//            completion(.failure(error))
//            return
//            #endif
            
            completion(.failure(error))
            return
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            let error = CustomErrors.systemDebug("invalid path for URL")
            completion(.failure(error))
            return
        }
        
        var httpBody: Data?
        if let parameters = parameters {
            
            switch method {
            case .get, .head, .delete:
                components.queryItems = parameters.map { key, value in 
                    URLQueryItem(name: key, value: value) 
                }
            default:
                do {
                    httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch {
                    completion(.failure(error))
                    return 
                }
            }
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        guard let requestUrl = components.url else {
            let error = CustomErrors.systemDebug("invalid path for URL")
            completion(.failure(error))
            return
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.timeoutInterval = 30
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = httpBody 
        
        request(urlRequest, validator: validator, percentageHandler: percentageHandler, completion: completion)
    }
    
    /// maybe add !data.isEmpty
    static let defaultValidator: ResponseValidator = { response in
        return (200 ..< 300) ~= response.statusCode
    }
    
    /// is not supported in Background Sessions
    /// https://stackoverflow.com/a/20605116/5893286
    ///
    /// percentageHandler will not be called if expectedContentLength of response in unknown 
    @discardableResult
    func request(_ urlRequest: URLRequest, validator: ResponseValidator?, percentageHandler: PercentageHandler?, completion: DataResult?) -> URLSessionTask {
        
        let task = urlSession.dataTask(with: urlRequest)
        
        let gtask = GenericTask(task: task, validator: validator)
        gtask.completionHandler = completion
        gtask.percentageHandler = percentageHandler
        tasks.append(gtask)
        gtask.resume()
        
        return task
    }
}

// MARK: - URLSessionDelegate
extension URLSessionWrapper: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
    }
    
    
    /// called every time
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        completionHandler(.performDefaultHandling, nil)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            self.backgroundCompletionHandler?()
        }
    }
}

// MARK: - URLSessionDataDelegate
extension URLSessionWrapper: URLSessionDataDelegate {
    
    /// called every time
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        
        guard let task = tasks.first(where: { $0.task == dataTask }), let response = response as? HTTPURLResponse else {
            completionHandler(.cancel)
            return
        }
        
        if let validator = task.validator, !validator(response) {
            task.validatorError = CustomErrors.systemDebug(response.description)
            completionHandler(.cancel)
            return
        }
        
        task.expectedContentLength = response.expectedContentLength
        task.progress.totalUnitCount = response.expectedContentLength
        
        completionHandler(.allow)
    }
    
    
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
//        
//    }
    
    
    /// success result
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        guard let task = tasks.first(where: { $0.task == dataTask }) else {
            return
        }
        task.buffer.append(data)
        
        if task.expectedContentLength == NSURLResponseUnknownLength {
            return
        }
        
        let percentageDownloaded = Double(task.buffer.count) / Double(task.expectedContentLength)
        
        DispatchQueue.main.async {
            task.percentageHandler?(percentageDownloaded)
            
            // TODO: proress handler
//            task.progress.completedUnitCount = Int64(task.buffer.count)
        }
        
//        print(String(data: data, encoding: .utf8) ?? "nil")
    }
    
    /// called every time
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void) {
        completionHandler(proposedResponse)
    }
}

// MARK: - URLSessionDownloadDelegate
//extension URLSessionWrapper: URLSessionDownloadDelegate {
//    /// required
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        
//        /// https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_in_the_background
//        guard
//            let httpResponse = downloadTask.response as? HTTPURLResponse,
//            (200...299).contains(httpResponse.statusCode)
//        else {
//            print ("server error")
//            return
//        }
//        
//        do {
//            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
//                                                           appropriateFor: nil, create: false)
//            let savedURL = documentsURL.appendingPathComponent(location.lastPathComponent)
//            try FileManager.default.moveItem(at: location, to: savedURL)
//        } catch {
//            print ("file error: \(error)")
//        }
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
//        
//    }
//}

// MARK: - URLSessionTaskDelegate
extension URLSessionWrapper: URLSessionTaskDelegate {
    
    /// will be called for background sessions
    /// This delegate method should only be implemented if the request might become stale while waiting for the network load and needs to be replaced by a new request
//    @available(iOS 11.0, *)
//    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Swift.Void) {
//        completionHandler(.continueLoading, request)
//    }
//    
//    
//    @available(iOS 11.0, *)
//    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void) {
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void) {
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        
//    }
//    
//    
//    /// called every time
//    /// URLSessionTaskMetrics is detailed info
//    @available(iOS 10.0, *)
//    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
//        
//    }
    
    /// called every time
    /// on success error == nil
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        guard let index = tasks.index(where: { $0.task == task }) else {
            return
        }
        
        let gtask = tasks.remove(at: index)
        
        DispatchQueue.global().async { [weak self] in
            if let validatorError = gtask.validatorError {
                gtask.completionHandler?(.failure(validatorError))
            } else if let error = error {
                
                /// retrier
                if let error = error as? URLError, let originalRequest = gtask.task.originalRequest {
                    
                    if error.code == .cancelled {
                        // TODO: handle cancel
                    } else {
                        print("retry")
                        // TODO: wait time
                        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                            self?.request(originalRequest, validator: gtask.validator, percentageHandler: gtask.percentageHandler, completion: gtask.completionHandler)
                        }
                    }
                    
                } else {
                    gtask.completionHandler?(.failure(error))
                }
                
                
            } else {
                gtask.completionHandler?(.success(gtask.buffer))
            }
        }
    }
}

// MARK: - URLSessionStreamDelegate
//extension URLSessionWrapper: URLSessionStreamDelegate {
//    
//    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
//        
//    }
//    
//    
//    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
//        
//    }
//}


// MARK: - static
extension URLSessionWrapper {
    
    /// https://github.com/Alamofire/Alamofire/blob/master/Source/SessionManager.swift
    /// Creates default values for the "Accept-Encoding", "Accept-Language" and "User-Agent" headers.
    static let defaultHTTPHeaders: HTTPheaders = {
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        
        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")
        
        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        // Example: `iOS Example/1.0 (org.alamofire.iOS-Example; build:1; iOS 10.0.0) Alamofire/4.0.0`
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                
                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    
                    let osName: String = {
                        #if os(iOS)
                        return "iOS"
                        #elseif os(watchOS)
                        return "watchOS"
                        #elseif os(tvOS)
                        return "tvOS"
                        #elseif os(macOS)
                        return "OS X"
                        #elseif os(Linux)
                        return "Linux"
                        #else
                        return "Unknown"
                        #endif
                    }()
                    
                    return "\(osName) \(versionString)"
                }()
                
                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion))"
            }
            
            return "Alamofire"
        }()
        
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()
}



