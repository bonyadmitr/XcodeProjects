//import Foundation
//
//class APISerivice: NSObject {
//
//    //let baseUrl = URL(string: "URL")!
//    let basePath = "URL"
//
//    let delegateQueue = OperationQueue()
//
//    lazy var urlSession: URLSession = {
//        let config = URLSessionConfiguration.default
//        config.httpAdditionalHeaders = defalutHeaders
//        if let accessToken = TokenStorage.shared.accessToken {
//            config.httpAdditionalHeaders?["ACCESS"] = accessToken
//        }
//        return URLSession(configuration: config, delegate: self, delegateQueue: delegateQueue)
//    }()
//
//    private let defalutHeaders: [String: String] = ["Content-Type": "application/json"]
//
//    func updateUrlSession(for accessToken: String) {
//        let config = URLSessionConfiguration.default
//        config.httpAdditionalHeaders = defalutHeaders
//        config.httpAdditionalHeaders?["ACCESS"] = accessToken
//        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: delegateQueue)
//    }
//
//    func refreshAccessToken(_ completion: @escaping () -> Void) {
//
//        guard let refreshToken = TokenStorage.shared.refreshToken else {
//            assertionFailure()
//            return
//        }
//
//        let path = basePath + "auth/rememberMe"
//        guard let url = URL(string: path) else {
//            assertionFailure()
//            return
//        }
//
//        let parameters: [String: Any] = [
//            "name": "Postman",
//            "deviceType": "IPHONE",
//            "uuid": "621DF1D4-D76E-451C-9609-8B54E7A4F8C1"
//        ]
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpBody = httpBody(from: parameters)
//        urlRequest.httpMethod = "POST"
//        urlRequest.allHTTPHeaderFields = ["REFRESH": refreshToken]
//        //        urlRequest.allHTTPHeaderFields = defalutHeaders
//        //        urlRequest.addValue(refreshToken, forHTTPHeaderField: "REFRESH")
//
//        assert(urlRequest.httpBody != nil)
//
//        //URLSession.shared
//        urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
//
//            // check internet problem
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                assertionFailure()
//                return
//            }
//
//            guard httpResponse.statusCode == 200 else {
//                // error
//                assertionFailure()
//                return
//            }
//
//            guard
//                let accessToken = httpResponse.allHeaderFields["ACCESS"] as? String
//                else {
//                    assertionFailure("server problem")
//                    return
//            }
//            TokenStorage.shared.accessToken = accessToken
//
//            self?.updateUrlSession(for: accessToken)
//
//            completion()
//
//            //            print(response)
//            //            print(String(data: data!, encoding: .utf8))
//            //            print()
//            }.resume()
//    }
//
//
//    func httpBody(from parameters: [String: Any]) -> Data? {
//        return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//    }
//
//    /// setAuthToken(for: &urlRequest)
//    //func setAuthToken(for request: inout URLRequest) {
//    //    if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
//    //        request.addValue(accessToken, forHTTPHeaderField: "ACCESS")
//    //    } else {
//    //        assertionFailure()
//    //    }
//    //}
//}
//
//extension APISerivice: URLSessionDelegate {
//}
//
////extension URLRequest {
////    mutating func setAuthToken() {
////        if let accessToken = TokenStorage.shared.accessToken {
////            addValue(accessToken, forHTTPHeaderField: "ACCESS")
////        } else {
////            assertionFailure()
////        }
////    }
////}
//
//
////-------------------------------------------------------------------------------
//
//
//final class AuthService: APISerivice {
//
//    func login(credentials: String, password: String) {
//
//        //        let url = baseUrl.appendingPathComponent("auth/token")
//        //        //let url = baseUrl.appendingPathComponent("auth/token?rememberMe=on")
//        //
//        //        guard var conponents = URLComponents(string: url.absoluteString) else {
//        //            return
//        //        }
//        //        conponents.queryItems = [URLQueryItem(name: "rememberMe", value: "on")]
//
//
//        let path = basePath + "URL"
//        guard let url = URL(string: path) else {
//            assertionFailure()
//            return
//        }
//
//        let parameters: [String: Any] = [
//            "username": credentials,
//            "password": password
//        ]
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpBody = httpBody(from: parameters)
//        urlRequest.httpMethod = "POST"
//        //        urlRequest.setAuthToken()
//
//        assert(urlRequest.httpBody != nil)
//
//
//        urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
//
//            // check internet problem
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                assertionFailure()
//                return
//            }
//
//            guard httpResponse.statusCode == 200 else {
//                // error
//                assertionFailure()
//                return
//            }
//
//            guard
//                let refreshToken = httpResponse.allHeaderFields["REFRESH"] as? String,
//                let accessToken = httpResponse.allHeaderFields["ACCESS"] as? String
//                else {
//                    assertionFailure("server problem")
//                    return
//            }
//            TokenStorage.shared.refreshToken = refreshToken
//            TokenStorage.shared.accessToken = accessToken
//
//            self?.updateUrlSession(for: accessToken)
//
//            //self?.urlSession.configuration.httpAdditionalHeaders = ["ACCESS": accessToken]
//
//            print(refreshToken)
//            print(accessToken)
//
//            //            print(response)
//            //            print(String(data: data!, encoding: .utf8))
//            //            print()
//            }.resume()
//
//    }
//
//}
//
//final class SearchService: APISerivice {
//
//
//    func getImages(hadler: @escaping (Result<RemoteItem, Error>) -> Void) {
//
//        let path = basePath + "URL"
//        guard let url = URL(string: path) else {
//            assertionFailure()
//            return
//        }
//
//        let urlRequest = URLRequest(url: url)
//
//        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
//            // check internet problem
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                assertionFailure()
//                return
//            }
//
//            if httpResponse.statusCode == 401 {
//                self?.refreshAccessToken {
//                    self?.getImages(hadler: hadler)
//                }
//                return
//            }
//
//            guard httpResponse.statusCode == 200 else {
//                // error
//                assertionFailure()
//                return
//            }
//
//
//
//
//            //            print(response)
//            print(String(data: data!, encoding: .utf8) ?? "nil")
//            //            print()
//        }
//        task.resume()
//    }
//}
//
//final class TokenStorage {
//
//    static let shared = TokenStorage()
//
//    var refreshToken: String? {
//        get {
//            return UserDefaults.standard.string(forKey: "refreshToken")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "refreshToken")
//        }
//    }
//
//    var accessToken: String? {
//        get {
//            return UserDefaults.standard.string(forKey: "accessToken")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "accessToken")
//        }
//    }
//}
