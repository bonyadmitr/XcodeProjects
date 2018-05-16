//
//  ViewController.swift
//  EventKitTest
//
//  Created by Bondar Yaroslav on 21/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

// https://developer.apple.com/reference/eventkitui

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Privacy - Calendars Usage Description
        let es = EKEventStore()
        es.requestAccess(to: .event) { (success, error) in
            print(success, error?.localizedDescription ?? "nil")
        }
    }
    
    
    let vc = EKEventViewController()
    @IBAction func actionShowButton(_ sender: UIButton) {
        vc.allowsEditing = true
        vc.delegate = self
        vc.view.backgroundColor = UIColor.red
        presentInNavVc(vc, doneAction: #selector(doneAction))
    }
    
    func doneAction() {
        vc.dismissSelf()
    }
}
extension ViewController: EKEventViewDelegate {
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    
    @IBAction func dismissSelf() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func presentInNavVc(_ controller: UIViewController, doneAction: Selector? = nil) {
        
        let nvc = UINavigationController(rootViewController: controller)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(dismissSelf))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: doneAction)
        controller.navigationItem.leftBarButtonItem = cancelButton
        controller.navigationItem.rightBarButtonItem = doneButton
        present(nvc, animated: true, completion: nil)
    }
}
