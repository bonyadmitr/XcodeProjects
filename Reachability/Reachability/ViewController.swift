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
        updateUserInterface(for: networkReachability)
    }
    
    private func updateUserInterface(for networkReachability: NetworkReachability) {
        switch networkReachability.connection {
        case .none:
            view.backgroundColor = .red
        case .cellular:
            view.backgroundColor = .yellow
        case .wifi:
            networkReachability.checkInternetConnection { [weak self] isReachable in
                DispatchQueue.main.async {
                    if isReachable {
                        self?.view.backgroundColor = .green
                    } else {
                        self?.view.backgroundColor = .red
                    }
                }
            }
        }
        
        print(networkReachability.connection)
    }
}

extension ViewController: NetworkReachabilityListener {
    func networkReachabilityChangedConnection(_ networkReachability: NetworkReachability) {
        DispatchQueue.main.async {
            self.updateUserInterface(for: networkReachability)
        }
    }
}
