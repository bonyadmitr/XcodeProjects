//
//  ViewController.swift
//  TextInputBar
//
//  Created by Yaroslav Bondar on 11.04.2023.
//

import UIKit

class ViewController: UIViewController {

    private let textInputBar = TextInputBar.initFromNib()
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
//        if #available(iOS 15.0, *) {
//            UITableView.appearance().sectionHeaderTopPadding = 0
//        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapGesture)
        
        //becomeFirstResponder()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        

    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override var inputAccessoryView: UIView? {
        textInputBar
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        onTap()
//    }
    
//    deinit {
//        onTap()
//    }
    
//            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
////            textInputBar.frame.origin.y = frame.origin.y
//
//            let insets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
//            tableView.contentInset = insets
//            tableView.scrollIndicatorInsets = insets
