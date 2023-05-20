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
