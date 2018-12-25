//
//  AppDelegate.swift
//  Tetris
//
//  Created by Yaroslav Bondar on 24/12/2018.
//  Copyright © 2018 Yaroslav Bondar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = GameController()
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}

import UIKit

final class GameController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        //view = GameView()
    }
    
    /// don't call super.loadView()
    /// "view = ..." in setup() will not call viewDidLoad
    override func loadView() {
        view = GameView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view().backgroundColor = .red
    }
}

extension GameController: ViewSpecificController {
    typealias RootView = GameView
}

final class GameView: UIView {
    
    let cellSpace: CGFloat = 1
    var boardWidthSize: CGFloat = 20
    var cellSize: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        /// add insets
        
        cellSize = bounds.width / (boardWidthSize + cellSpace)
        
        let numberOfLines = 30
        
        for i in 0..<Int(boardWidthSize) {
            for j in 0..<numberOfLines {
                let cellY = bounds.height - CGFloat(j) * (cellSpace + cellSize)
                
                let layer = CALayer()
                layer.frame = CGRect(x: CGFloat(i) * (cellSize + cellSpace), y: cellY, width: cellSize, height: cellSize)
                layer.backgroundColor = UIColor.red.cgColor
                self.layer.addSublayer(layer)
            }
            
        }
    }
}

protocol ViewSpecificController {
    associatedtype RootView: UIView
}
extension ViewSpecificController where Self: UIViewController {
    func view() -> RootView {
        return self.view as! RootView
    }
}
