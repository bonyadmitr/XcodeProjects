//
//  ViewController.swift
//  PresentVC
//
//  Created by Yaroslav Bondar on 25.05.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        presentDismissAnimationFix()
        
        /// remove FixedNavigationController from Main.storyboard
        
//        //CATransaction.commit()
//        CATransaction.begin()
//        CATransaction.setCompletionBlock {
//            print("- setCompletionBlock 1")
//        }
//        CATransaction.begin()
//        CATransaction.setCompletionBlock {
//            print("- setCompletionBlock 2")
//        }
//        pushCrash()
//        CATransaction.setCompletionBlock {
//            print("- setCompletionBlock 3")
//        }
//        CATransaction.commit()
//        CATransaction.commit()
        
        
//        pushCrash2()
//        pushCrash3()
        
        
    }

    private func presentDismissAnimationFix() {
        modalPresentationStyle = .fullScreen
        let delay: TimeInterval = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let vc1 = UIViewController()
            vc1.view.backgroundColor = .red
            vc1.modalPresentationStyle = .fullScreen
            self.present(vc1, animated: true, completion: nil)
            
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                let vc2 = UIViewController()
                vc2.view.backgroundColor = .blue
                vc2.modalPresentationStyle = .fullScreen
                
                let someView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 100))
                someView.backgroundColor = .green
                vc2.view.addSubview(someView)
                
                vc1.present(vc2, animated: true, completion: nil)
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    //                    vc1.view.addSubview(vc2.view.copyView())
                    //                    self.dismiss(animated: true, completion: nil)
                    
                    vc2.presentingViewController?.view.addSubview(vc2.view.copyView())
                    /// if need
                    //vc2.presentingViewController?.dismiss(animated: false, completion: nil)
                    //vc2.dismiss(animated: false, completion: nil)
                    vc2.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    
                }
                
                
            }
        }
    }
    
    private func pushCrash() {
        DispatchQueue.main.async {
            /// need 3 calles for simulator iOS 14 and 2 calles for device ios 13
            self.navigationController?.pushViewController(UIViewController(), animated: true)
            self.navigationController?.pushViewController(UIViewController(), animated: true)
            self.navigationController?.pushViewController(UIViewController(), animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
