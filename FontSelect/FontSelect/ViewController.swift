//
//  ViewController.swift
//  FontSelect
//
//  Created by zdaecqze zdaecq on 28.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var inputTextField: UITextField! {
        didSet { inputTextField.inputView = UIView() }
    }
    
    let segueSelectFont = "SelectFont"
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        inputTextField.inputView = UIView()
//    }
    
    @IBAction func textEditDidBegin(_ sender: UITextField) {
        performSegue(withIdentifier: segueSelectFont, sender: nil)
    }
    
    @IBAction func backToVC(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueSelectFont {
            let navVC = segue.destination as! UINavigationController
            let vc = navVC.topViewController as! FontsController
            vc.delegate = self
        }
    }
}

extension ViewController: FontsControllerDelegate {
    func didSelectFont(fontName: String) {
        titleTextField.font = UIFont(name: fontName, size: 17)
        inputTextField.text = fontName
    }
    
    func didSelectDefaultFont(font: UIFont) {
        titleTextField.font = font
        inputTextField.text = font.fontName
    }
    
}
