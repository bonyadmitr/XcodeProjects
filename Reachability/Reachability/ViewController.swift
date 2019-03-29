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
        
        setupReachability()
    }
    
    private func setupReachability() {
        guard let reachability = Reachability.shared else  {
            assertionFailure()
            return
        }
        reachability.register(self)
        updateUserInterface(for: reachability.connection)
    }

    private func updateUserInterface(for connection: Reachability.Connection) {
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

extension ViewController: ReachabilitySubscriber {
    func reachabilityChanged(_ reachability: Reachability) {
        DispatchQueue.main.async {
            self.updateUserInterface(for: reachability.connection)
        }

    }
}
