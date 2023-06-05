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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 66.0
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: "UserChatCell", bundle: nil), forCellReuseIdentifier: "UserChatCell")
        tableView.register(UINib(nibName: "AssistantChatCell", bundle: nil), forCellReuseIdentifier: "AssistantChatCell")
        
        textInputBar.onSizeChange = { [weak self] in
            guard let self = self else {
                return
            }
            
            UIView.animate(withDuration: 0.25) {
                let height: CGFloat = -self.bottomTextInputBarConstraint.constant + self.textInputBar.bounds.height - (UIDevice.hasNotch ? 34 : 0)
                let insets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
                self.tableView.contentInset = insets
                self.tableView.scrollIndicatorInsets = insets
                
                let isReachingEnd = self.tableView.contentOffset.y >= 0 && self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.frame.size.height)
                if isReachingEnd {
                    self.tableView.scrollToRow(at: IndexPath(row: 29 , section: 0), at: .bottom, animated: false)
                }

            }
        }
    }
    
    @objc private func onTap() {
        textInputBar.textView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        
        let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = frame.height
        self.bottomTextInputBarConstraint.constant = -height
        
        func animations() {
            self.view.layoutIfNeeded()
            
            let insetHeight: CGFloat = height + self.textInputBar.bounds.height - (UIDevice.hasNotch ? 34 : 0)
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: insetHeight, right: 0)
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
            
            
//
            let isReachingEnd = self.tableView.contentOffset.y >= 0 && self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.frame.size.height)
            if isReachingEnd {
                self.tableView.scrollToRow(at: IndexPath(row: 29 , section: 0), at: .bottom, animated: false)
            }
        }
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else {
            animations()
            return
        }
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curveRawValue), animations: { ()->() in
            animations()
        }, completion: nil)
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: self.textInputBar.bounds.height, right: 0)
        
        func animations() {
            let height: CGFloat = 0//textInputBar.bounds.height +
            self.bottomTextInputBarConstraint.constant = -height
            self.view.layoutIfNeeded()
            
            
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
        }
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else {
            animations()
            return
        }
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curveRawValue), animations: { ()->() in
            animations()
        }, completion: nil)
    }
    
    
    @objc func keyboardFrameChanged(notification: NSNotification) {
            print("keyboardFrameChanged")
    }
    
}

extension ViewController2: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCell", for: indexPath) as? UserChatCell else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.setup(with: "Row \(indexPath.row + 1). \(randomString(length: .random(in: 2...100)))")
        //cell.backgroundColor = .red
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Row \(indexPath.row + 1)"
//        //cell.backgroundColor = .red
//        return cell
        
        
    }
    
    
    
}
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        guard let cell = tableView.cellForRow(at: indexPath) else {
//            assertionFailure()
//            return nil
//        }
        
        let text = "Row \(indexPath.row + 1)"
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { action in
                UIPasteboard.general.string = text
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
                let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                self?.present(activityViewController, animated: true, completion: nil)
            }
            return UIMenu(title: "", children: [shareAction, copyAction])
        }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        targetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        targetedPreview(for: configuration)
    }
    }
    
}
