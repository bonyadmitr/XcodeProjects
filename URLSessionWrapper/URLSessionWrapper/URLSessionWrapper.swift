//
//  URLSessionWrapper.swift
//  URLSessionWrapper
//
//  Created by Bondar Yaroslav on 6/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias VoidResult = (Result<Void>) -> Void
typealias BoolResult = (Result<Bool>) -> Void
typealias DataResult = (Result<Data>) -> Void
typealias HandlerResult<T> = (Result<T>) -> Void
typealias ArrayHandlerResult<T> = (Result<[T]>) -> Void

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias HTTPheaders = [String: String]
typealias HTTPParameters = [String: String]
typealias ResponseValidator = (Data, HTTPURLResponse) -> Bool

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case head = "HEAD"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

// MARK: - class
final class URLSessionWrapper: NSObject {
    
    static let shared = URLSessionWrapper()
    
//    lazy var downloadsSession: URLSession = {
//        let configuration = URLSessionConfiguration.default
//        configuration.allowsCellularAccess = true /// default true, check false
////        configuration.httpCookieAcceptPolicy = .always
////        configuration.httpAdditionalHeaders = ["": ""]
//        configuration.requestCachePolicy = .useProtocolCachePolicy /// default
//        configuration.timeoutIntervalForRequest = 30 /// default 60
//        
//        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
//    }()
    
    var backgroundCompletionHandler: (() -> Void)?
    
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
        
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()



    

    
//    var tasks = [URLSessionTask]()
    
    func request(_ method: HTTPMethod, path: String, headers: HTTPheaders?, parameters: HTTPParameters?, validator: ResponseValidator? = defaultValidator, completion: @escaping DataResult) {
        
        guard var components = URLComponents(string: path) else {
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
        
        guard let url = components.url else {
            let error = CustomErrors.systemDebug("invalid path for URL")
            completion(.failure(error))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = httpBody 
        
//        let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
        
        request(urlRequest, validator: validator, completion: completion)
    }
    
    /// maybe add !data.isEmpty
    static let defaultValidator: ResponseValidator = { data, response in
        return (200 ..< 300) ~= response.statusCode
    }
    
    @discardableResult
    func request(_ urlRequest: URLRequest, validator: ResponseValidator? = defaultValidator, completion: @escaping DataResult) -> URLSessionTask {
        
        let task = urlSession.dataTask(with: urlRequest)
//        tasks.append(task)
        
//        { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                
//            } else if let data = data, let response = response as? HTTPURLResponse {
//                
//                if let validator = validator {
//                    if validator(data, response) {
//                        completion(.success(data))
//                    } else {
//                        // TODO: error
//                        let error = CustomErrors.systemDebug("failed responseValidator \(validator), \(response)")
//                        completion(.failure(error))
//                    }
//                } else {
//                    completion(.success(data))
//                }
//                
//            } else {
//                let error = CustomErrors.systemDebug(response?.description ?? "response nil")
//                completion(.failure(error))
//            }
//        }
        task.resume()
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
        completionHandler(.allow)
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        
    }
    
    
    /// success result
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(String(data: data, encoding: .utf8) ?? "nil")
    }
    
    /// called every time
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void) {
        completionHandler(proposedResponse)
    }
}

// MARK: - URLSessionDownloadDelegate
extension URLSessionWrapper: URLSessionDownloadDelegate {
    /// required
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        /// https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_in_the_background
        guard
            let httpResponse = downloadTask.response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            print ("server error")
            return
        }
        
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                           appropriateFor: nil, create: false)
            let savedURL = documentsURL.appendingPathComponent(location.lastPathComponent)
            try FileManager.default.moveItem(at: location, to: savedURL)
        } catch {
            print ("file error: \(error)")
        }
        
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
}

// MARK: - URLSessionTaskDelegate
extension URLSessionWrapper: URLSessionTaskDelegate {
    
    /// will be called for background sessions
    /// This delegate method should only be implemented if the request might become stale while waiting for the network load and needs to be replaced by a new request
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Swift.Void) {
        completionHandler(.continueLoading, request)
    }
    
    
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void) {
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void) {
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    
    /// called every time
    /// URLSessionTaskMetrics is detailed info
    @available(iOS 10.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        
    }
    
    
    /// called every time
    /// on success error == nil
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
}

// MARK: - URLSessionStreamDelegate
extension URLSessionWrapper: URLSessionStreamDelegate {
    
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        
    }
    
    
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        
    }
    
    
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        
    }
    
    
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        
    }
}


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



