//
//  ViewController.swift
//  iPadComponents
//
//  Created by Bondar Yaroslav on 14/05/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction private func showAlertVC(_ sender: UIButton) {
        let vc = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("OK")
        }
        vc.addAction(okAction)
        vc.addAction(cancelAction)
        
        if Device.isIpad {
            /// You must provide either a sourceView and sourceRect or a barButtonItem
            
            /// #1
            //vc.popoverPresentationController?.sourceView = sender
            
            /// #2
            
            /// #a
            //let originPoint = CGPoint(x: UIScreen.main.bounds.width / 2 - vc.preferredContentSize.width / 2,
            //                          y: UIScreen.main.bounds.height / 2 - vc.preferredContentSize.height / 2)
            //vc.popoverPresentationController?.sourceRect = CGRect(origin: originPoint, size: vc.preferredContentSize)
            
            /// #b
            //vc.popoverPresentationController?.sourceRect = CGRect(origin: view.center, size: .zero)
            /// #c
            vc.popoverPresentationController?.sourceRect = UIScreen.main.bounds
            
            vc.popoverPresentationController?.sourceView = view
            
            /// means no arrow. ".init(rawValue: 0)" same as "[]"
            vc.popoverPresentationController?.permittedArrowDirections = []
            
            
            //vc.preferredContentSize
        } else {
            /// iPad popover style for iPhone
            //vc.modalPresentationStyle = .popover ///???
            //vc.popoverPresentationController?.delegate = self
            
            //vc.popoverPresentationController?.sourceView = sender
            //vc.popoverPresentationController?.sourceRect = sender.frame bounds ///check
        }
        
        
        
        present(vc, animated: true, completion: nil)
    }
}

//extension ViewController: UIPopoverPresentationControllerDelegate {
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }

    /// ???
//    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
//        childViewControllers.forEach { $0.removeFromParentViewController() }
//        return true
//    }
//}

