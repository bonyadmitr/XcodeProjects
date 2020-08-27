//
//  ViewController.swift
//  RaisedTabBar
//
//  Created by Bondar Yaroslav on 8/17/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// DispatchWorkItem cancel https://stackoverflow.com/a/38372384/5893286
/// source https://gist.github.com/daehn/414212e1b4b30a43d995e4b5a4c2dad7
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


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let throttle = Throttle(delay: 1, queue: .main)
        
        for _ in 1...100 {
            throttle.call {
                print("- throttle")
            }
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delayedFunction), object: nil)
            perform(#selector(delayedFunction), with: nil, afterDelay: 1)
        }
        
        // TODO: add tab br controller
        // TODO: add alert sheet for Raisedbutton for different controllers
    }
    
    @objc private func delayedFunction() {
        print("- delayedFunction")
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
