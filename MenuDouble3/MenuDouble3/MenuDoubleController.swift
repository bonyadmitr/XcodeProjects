//
//  MenuDoubleController.swift
//  MenuDouble3
//
//  Created by Bondar Yaroslav on 15/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum ProgressType {
    case moving
    case finish
}

protocol MenuDoubleDelegate: class {
    /// progress: 0...1
    func leftMenuOpening(progress: CGFloat, type: ProgressType)
    func actionEditButton(_ sender: UIButton)
}
extension MenuDoubleDelegate {
    func actionEditButton(_ sender: UIButton) {}
}

class MenuDoubleController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var leftContainer: UIView!
    @IBOutlet weak var rightContainer: UIView!
    @IBOutlet weak var mainContainer: UIView!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    weak var leftVC: UIViewController!
    weak var rightVC: UIViewController!
    weak var mainVC: UIViewController!
    
    var delegates = MulticastDelegate<MenuDoubleDelegate>()
    
    var panGesture: MenuPanGesture!
    var rightTapGesture: UITapGestureRecognizer!
    
    // MARK: - Sizes
    
    var leftInset: CGFloat = 0 // placeholder value
    var rightInset: CGFloat = 80 // placeholder value
    let screenWidth = UIScreen.main.bounds.width
    let mid = UIScreen.main.bounds.width / 2
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupContainers()
        setupShadow()
        setupPanGesture()
        setupRightTapGesture()
    }
    
    func setupConstraints() {
        leftInset = leftConstraint.constant
        rightInset = rightConstraint.constant
        leftWidthConstraint.constant = screenWidth - leftInset - rightInset
        rightWidthConstraint.constant = screenWidth - rightInset
        
        /// to close menu
        leftConstraint.constant = -screenWidth
        rightConstraint.constant = rightInset
    }
    
    func setupPanGesture() {
        panGesture = MenuPanGesture(target: self, action: #selector(actionPanGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    func setupRightTapGesture() {
        rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(openRightMenu))
        rightTapGesture.cancelsTouchesInView = false
        rightTapGesture.isEnabled = false
        rightContainer.addGestureRecognizer(rightTapGesture)
    }
    
    func setupContainers() {
        performSegue(withIdentifier: "right", sender: nil)
        performSegue(withIdentifier: "left", sender: nil)
        performSegue(withIdentifier: "main", sender: nil)
    }
    
    /// can be added shouldRasterize with rasterizationScale and shadowPath for optimization
    func setupShadow() {
        rightContainer.layer.shadowRadius = 3
        rightContainer.layer.shadowOffset = CGSize(width: -4, height: 0)
        rightContainer.layer.shadowColor = UIColor.black.cgColor
        rightContainer.layer.shadowOpacity = 0.5
    }
    
    // MARK: - Methods
    
    func openMain() {
        leftConstraint.constant = -screenWidth
        rightConstraint.constant = rightInset
        updateConstraints()
        menuState = .main
    }
    
    func openRightMenu() {
        leftConstraint.constant = leftInset
        rightConstraint.constant = rightInset
        updateConstraints()
        rightTapGesture.isEnabled = false
        menuState = .right
    }
    
    func openLeftMenu() {
        leftConstraint.constant = leftInset
        rightConstraint.constant = leftContainer.frame.maxX
        updateConstraints()
        rightTapGesture.isEnabled = true
        menuState = .left
    }
    
    func updateConstraints() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction], animations: {
            self.invokeDelegates(type: .finish)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    // MARK: - End pan
    
    enum MenuState {
        case main
        case right
        case left
    }
    
    var menuState = MenuState.main
    
    private func endPan(with velocity: CGFloat) {
        
        if abs(velocity) < 300 {
            if mainContainer.frame.minX < mid {
                openMain()
            } else if rightContainer.frame.minX < mid {
                openRightMenu()
            } else {
                openLeftMenu()
            }
            return
        }
        
        switch menuState {
        case .main:
            if velocity > 0 {
                openRightMenu()
            } else {
                openMain()
            }
        case .right:
            if velocity > 0 {
                openLeftMenu()
            } else {
                openMain()
            }
        case .left:
            if velocity < 0 {
                openRightMenu()
            } else {
                openLeftMenu()
            }
        }
    }
    
    private func invokeDelegates(type: ProgressType) {
        let progress = (rightConstraint.constant - rightInset) / (leftWidthConstraint.constant - rightInset)
        delegates.invoke { delegate in
            delegate.leftMenuOpening(progress: progress, type: type)
        }
    }
    
    // MARK: - PanGesture action
    
    @objc private func actionPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let deltaX = gesture.translation(in: view).x
        
        // TODO: need to optimize
        if rightConstraint.constant == rightInset {
            
            if leftConstraint.constant + deltaX > leftInset {
                leftConstraint.constant = leftInset
                
                if rightConstraint.constant + deltaX > leftContainer.frame.maxX {
                    rightConstraint.constant = leftContainer.frame.maxX
                } else if rightConstraint.constant + deltaX < rightInset {
                    rightConstraint.constant = rightInset
                } else {
                    rightConstraint.constant += deltaX
                }
                
                invokeDelegates(type: .moving)
                
            } else if leftConstraint.constant + deltaX < -screenWidth {
                leftConstraint.constant = -screenWidth
            } else {
                leftConstraint.constant += deltaX
            }
            
        } else {
            
            if rightConstraint.constant + deltaX > leftContainer.frame.maxX {
                rightConstraint.constant = leftContainer.frame.maxX
            } else if rightConstraint.constant + deltaX < rightInset {
                rightConstraint.constant = rightInset
            } else {
                rightConstraint.constant += deltaX
            }
            
            invokeDelegates(type: .moving)
        }
        
        gesture.setTranslation(.zero, in: view)
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            let velocity = gesture.velocity(in: view).x
            endPan(with: velocity)
        }
    }
}
