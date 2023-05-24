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
        
        print("textInputBar.bounds.height \(textInputBar.bounds.height)")
        //let insets = UIEdgeInsets(top: 0, left: 0, bottom: textInputBar.bounds.height, right: 0)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 86, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    @objc private func onTap() {
        textInputBar.textView.resignFirstResponder()
    }

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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        if let userInfo = notification.userInfo {
//            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
////            textInputBar.frame.origin.y = frame.origin.y
//
//            let insets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
//            tableView.contentInset = insets
//            tableView.scrollIndicatorInsets = insets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        
//        if let userInfo = notification.userInfo {
//            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
////            textInputBar.frame.origin.y = frame.origin.y
//
//            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            tableView.contentInset = insets
//            tableView.scrollIndicatorInsets = insets
//        }
    }
    
    
    @objc func keyboardFrameChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            print("keyboardFrameChanged", frame)
            
            let isReachingEnd = tableView.contentOffset.y >= 0 && tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height)
            if isReachingEnd {
                DispatchQueue.main.async {
                    self.tableView.scrollToRow(at: IndexPath(row: 29 , section: 0), at: .bottom, animated: true)
                }

            }
            print(isReachingEnd)
            
            
            //let insets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height - 33, right: 0)
            
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height - (UIDevice.hasNotch ? 34 : 0), right: 0)
//            print(frame.height)
            UIView.animate(withDuration: 0.3) {
                self.tableView.contentInset = insets
                self.tableView.scrollIndicatorInsets = insets

            }
        }
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        //cell.backgroundColor = .red
        return cell
    }
    
}
