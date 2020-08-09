//
//  ViewController.swift
//  AnimatedTabBarController
//
//  Created by Bondar Yaroslav on 8/9/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIButton(type: .system)
        button1.setTitle("Tab", for: .normal)
        button1.addTarget(self, action: #selector(changeTab), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [button1])
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    @objc private func changeTab() {
        guard let tabBarController = tabBarController else {
            return
        }
        
        if tabBarController.selectedIndex + 1 == tabBarController.viewControllers?.count {
            tabBarController.selectedIndex = 0
        } else {
            tabBarController.selectedIndex += 1
        }
    }

}
