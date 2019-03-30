//
//  ViewController.swift
//  Reachability
//
//  Created by Bondar Yaroslav on 3/29/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 12.0, *) {
            _ = NetworkReachability2.shared
        } else {
            setupNetworkReachability()
        }
    }
    
    private func setupNetworkReachability() {
        guard let networkReachability = NetworkReachability.shared else  {
            assertionFailure()
            return
        }
        networkReachability.register(self)
        updateUserInterface(for: networkReachability.connection)
    }

    private func updateUserInterface(for connection: NetworkReachability.Connection) {
        switch connection {
        case .none:
//            view.backgroundColor = .red
            
            guard let url = URL(string: "https://www.google.com") else {
                assertionFailure()
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 0.5
            urlRequest.httpMethod = "HEAD"
            //urlRequest.cachePolicy = .reloadRevalidatingCacheData
            //urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            
            /// needs 3-4 kb of network for check
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let error = error as? URLError else {
                        self.view.backgroundColor = .green
                        return
                    }
                    
                    switch error.code {
                    case .timedOut:
                        print("there is no INTERNET connection or it is very slow")
                    case .notConnectedToInternet:
                        print("there is no NETWORK connection at all")
                    default:
                        print(error.localizedDescription)
                    }
                    
                    self.view.backgroundColor = .red
                }
                
                print(response ?? "1 nil")
                print(error ?? "2 nil")
                print()
                //view.backgroundColor = .green
                }.resume()
            
            
        case .wifi:
            guard let url = URL(string: "https://www.google.com") else {
                assertionFailure()
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 0.5
            urlRequest.httpMethod = "HEAD"
            //urlRequest.cachePolicy = .reloadRevalidatingCacheData
            //urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            
            /// needs 3-4 kb of network for check
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error as? URLError, error.code == .timedOut {
                        self.view.backgroundColor = .red
                    } else {
                        self.view.backgroundColor = .green
                    }
                }
                
                print(response ?? "1 nil")
                print(error ?? "2 nil")
                print()
                //view.backgroundColor = .green
            }.resume()
            
        case .cellular:
            //view.backgroundColor = .yellow
            
            guard let url = URL(string: "https://www.google.com") else {
                assertionFailure()
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 0.5
            urlRequest.httpMethod = "HEAD"
            //urlRequest.cachePolicy = .reloadRevalidatingCacheData
            //urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            
            /// needs 3-4 kb of network for check
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error as? URLError, error.code == .timedOut {
                        self.view.backgroundColor = .red
                    } else {
                        self.view.backgroundColor = .yellow
                    }
                }
                
                print(response ?? "1 nil")
                print(error ?? "2 nil")
                print()
                //view.backgroundColor = .green
                }.resume()
        }
        print(connection)
    }
}

extension ViewController: NetworkReachabilityListener {
    func networkReachability(_ networkReachability: NetworkReachability,
                             changed connection: NetworkReachability.Connection) {
        DispatchQueue.main.async {
            self.updateUserInterface(for: connection)
        }

    }
}
