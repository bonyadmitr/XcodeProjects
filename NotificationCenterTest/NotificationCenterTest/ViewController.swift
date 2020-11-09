//
//  ViewController.swift
//  NotificationCenterTest
//
//  Created by Yaroslav Bondr on 03.11.2020.
//

import UIKit

class ViewController: UIViewController {




}

extension NSNotification.Name {
    static let custom = NSNotification.Name(rawValue: "custom")
}

class ViewController2: UIViewController {
    
    var tokenRemover: TokenRemover?
    var notificationToken: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        //NotificationCenter.default.addObserver(self, selector: #selector(notif1), name: .custom, object: nil)
        
        tokenRemover = NotificationCenter.default.observe(name: .custom, object: nil, queue: .main) { [weak self] _ in
            print(self?.view.backgroundColor)
            print("did receave custom notification by block")
        }
        
        NotificationCenter.default.addObserver(forName: .custom, object: nil, queue: .main) { [weak self] _ in
            print(self?.view.backgroundColor)
            print("did receave custom notification by block")
        }
        
    }
    
    @objc private func notif1() {
        print("did receave custom notification")
    }
    
    deinit {
        if let notificationToken = notificationToken {
            NotificationCenter.default.removeObserver(notificationToken)
        }
        print("deinit ViewController2")
    }
    
}


final class TokenRemover {
    
    private let token: NSObjectProtocol /// can be `Any`
    private let notificationCenter: NotificationCenter
    
    init(token: NSObjectProtocol, notificationCenter: NotificationCenter) {
        self.token = token
        self.notificationCenter = notificationCenter
    }
    
    deinit {
        notificationCenter.removeObserver(token)
    }
    
}

extension NotificationCenter {
    
    /// Convenience wrapper for addObserver(forName:object:queue:using:)
    /// that returns our custom TokenRemover.
    func observe(name: NSNotification.Name?,
                 object obj: Any?,
                 queue: OperationQueue?,
                 using block: @escaping (Notification) -> ()) -> TokenRemover
    {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return TokenRemover(token: token, notificationCenter: self)
    }
    
}

