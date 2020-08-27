//
//  ViewController.swift
//  RaisedTabBar
//
//  Created by Bondar Yaroslav on 8/17/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
final class Throttle {
    
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    
    init(delay: TimeInterval, queue: DispatchQueue) {
        self.delay = delay
        self.queue = queue
    }
    
    /// item can be passed in block for long tasks
    func call(_ block: @escaping () -> Void) {
        workItem?.cancel()
        let item = DispatchWorkItem(block: block)
        workItem = item
        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }
    
}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: add tab br controller
        // TODO: add alert sheet for Raisedbutton for different controllers
    }

}

extension ViewController: RaisedTabBarHandler {
    func onRaisedButton() {
        print("onRaisedButton ViewController")
    }
}

extension ViewController: TabBarRaisedHandler {
    var tabBarRaisedActions: [TabBarRaisedAction] {
        let action = TabBarRaisedAction(title: "ViewController") {
            print("from ViewController")
        }
        return [.open, .add, action]
    }
}
