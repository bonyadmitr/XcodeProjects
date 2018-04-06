//
//  ErrorPresenter.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol ErrorPresenter {
    func showErrorAlert(with message: String)
}
extension ErrorPresenter where Self: UIViewController {
    func showErrorAlert(with message: String?) {
        let vc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        vc.addAction(okAction)
        present(vc, animated: false, completion: nil)
    }
}
