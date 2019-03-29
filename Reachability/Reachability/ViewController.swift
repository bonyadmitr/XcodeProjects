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
        
        setupNetworkReachability()
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
            view.backgroundColor = .red
        case .wifi:
            view.backgroundColor = .green
        case .cellular:
            view.backgroundColor = .yellow
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
