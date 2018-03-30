//
//  BackgroundDismissAlertController.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 29.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

final public class BackgroundDismissAlertController: UIAlertController {
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAlertTapBackground))
        view.superview?.subviews[1].addGestureRecognizer(tap)
        view.superview?.subviews[1].isUserInteractionEnabled = true
    }
    
    @objc private func dismissAlertTapBackground() {
        dismiss(animated: true, completion: nil)
    }
}
