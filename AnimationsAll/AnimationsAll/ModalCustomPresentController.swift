//
//  ModalCustomPresentController.swift
//
//
//  Created by Bondar Yaroslav on 27/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ModalCustomPresentController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let savedCenterPoint = backView.center
        
        backView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        backView.center = CGPoint(x: backView.center.x, y: 20)
        
        UIView.animate(withDuration: 0.2) {
            self.backView.transform = .identity
            self.backView.center = savedCenterPoint
        }
    }
    
    @IBAction func hideButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.backView.center = CGPoint(x: self.backView.center.x, y: 20)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}
