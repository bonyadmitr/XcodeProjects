//
//  ViewController.swift
//  StatusBarTap
//
//  Created by Yaroslav Bondr on 03.03.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        
        let scrollView = UIScrollView()
//        let scrollView = UITableView()
        scrollView.frame = view.frame
        scrollView.contentOffset.y = 1
        scrollView.contentSize.height = view.bounds.height + 1
        scrollView.delegate = self
        view.addSubview(scrollView)

    }

}

extension ViewController: UIScrollViewDelegate, UITableViewDelegate {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        print("ViewController status bar tapped")
        return true
    }
}
