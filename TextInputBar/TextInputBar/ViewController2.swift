//
//  ViewController2.swift
//  TextInputBar
//
//  Created by Yaroslav Bondar on 12.04.2023.
//

import UIKit

class ViewController2: UIViewController {
    
    private let textInputBar = TextInputBar.initFromNib()
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var bottomTextInputBarConstraint = textInputBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        //        if #available(iOS 15.0, *) {
        //            UITableView.appearance().sectionHeaderTopPadding = 0
        //        }
        
        
        view.addSubview(textInputBar)
        
        textInputBar.translatesAutoresizingMaskIntoConstraints = false
        textInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomTextInputBarConstraint.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapGesture)
        
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        textInputBar.layoutIfNeeded()
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: textInputBar.bounds.height, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
    }
    
}
