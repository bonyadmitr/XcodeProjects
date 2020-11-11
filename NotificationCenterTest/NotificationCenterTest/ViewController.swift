//
//  ViewController.swift
//  NotificationCenterTest
//
//  Created by Yaroslav Bondr on 03.11.2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            NotificationCenter.default.post(name: .custom, object: nil)
            print("did send custom notification 1")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            NotificationCenter.default.post(name: .custom, object: nil)
            print("did send custom notification 2")
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        present(ViewController2(), animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }



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




/// we need to call `notificationCenter.removeObserver` for closure syntax `addObserver(forName`
/// inspired article https://oleb.net/blog/2018/01/notificationcenter-removeobserver/
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

