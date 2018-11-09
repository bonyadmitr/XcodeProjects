//
//  FloatingController.swift
//  WindowFloating
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

#if DEBUG
import UIKit

final class FloatingController: UIViewController {
    
    private let button = FloatingView()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        button.updateOrientation(with: size)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.delegate = self
        view.backgroundColor = UIColor.clear
        let selector = #selector(actionPanGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: selector)
        button.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FloatingManager.shared.isDisplayedController = false
    }
    
    @objc func actionPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        /// animate on press
        if gesture.state == .began {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
        }
        
        let offset = gesture.translation(in: view)
        gesture.setTranslation(.zero, in: view)
        
        var center = button.center
        center.x += offset.x
        center.y += offset.y
        button.center = center
        
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            
            let location = gesture.location(in: view)
            let velocity = gesture.velocity(in: view)
            
            /// count x
            let horizontalInset: CGFloat = button.bounds.width * 0.5 
            let finalX: CGFloat
            let connectToRightScreenSide = location.x > UIScreen.main.bounds.width / 2
            if connectToRightScreenSide {
                finalX = UIScreen.main.bounds.width - horizontalInset
            } else {
                finalX = horizontalInset
            }
            
            /// count y
            let horizontalVelocity = abs(velocity.x)
            let positionX = abs(finalX - location.x)
            let velocityForce = sqrt(pow(velocity.x, 2) * pow(velocity.y, 2))
            let durationAnimation = (velocityForce > 1000.0) ? min(0.3, positionX / horizontalVelocity) : 0.3
            
            var finalY = location.y
            if velocityForce > 1000.0 {
                finalY += velocity.y * durationAnimation
            }
            
            let verticalInset: CGFloat = button.bounds.width * 0.5
            if finalY > UIScreen.main.bounds.size.height - verticalInset {
                finalY = UIScreen.main.bounds.size.height - verticalInset
            } else if finalY < verticalInset {
                let statusBarHeight: CGFloat = 20
                finalY = verticalInset + statusBarHeight
            }
            
            /// animate
            UIView.animate(
                withDuration: TimeInterval(durationAnimation * 5),
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 6,
                options: .allowUserInteraction,
                animations: {
                    self.button.center = CGPoint(x: finalX, y: finalY)
                    self.button.transform = .identity
            }, completion: nil)
        }
    }
    
    func shouldReceive(point: CGPoint) -> Bool {
        if FloatingManager.shared.isDisplayedController {
            return true
        }
        return button.frame.contains(point)
    }
}

extension FloatingController: FloatingViewDelegate {
    func didTapButton() {
        FloatingManager.shared.isDisplayedController = true
        if let vc = FloatingManager.shared.presentingController {
            present(vc, animated: true, completion: nil)
        }
    }
}
#endif
