//
//  ViewController.swift
//  NavigationBasic
//
//  Created by Bondar Yaroslav on 5/29/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIButton(type: .system)
        button1.setTitle("Push", for: .normal)
        button1.addTarget(self, action: #selector(push), for: .touchUpInside)
        
        let button2 = UIButton(type: .system)
        button2.setTitle("Present", for: .normal)
        button2.addTarget(self, action: #selector(presentVC), for: .touchUpInside)
        
        let button3 = UIButton(type: .system)
        button3.setTitle("Tab", for: .normal)
        button3.addTarget(self, action: #selector(changeTab), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [button1, button2, button3])
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc private func push() {
        let vc = ViewController()
        
        // TODO: example with
        //vc.hidesBottomBarWhenPushed = true
        
        vc.view.backgroundColor = .lightGray
        navigationController?.pushViewController(vc, animated: true)
        //navigationController?.replaceTopViewController(vc, animated: true)
    }
    
    @objc private func presentVC() {
        let vc = ViewController()
        vc.view.backgroundColor = .darkGray
        present(vc, animated: true)
    }
    
    @objc private func changeTab() {
//        if let tabBarController = tabBarController {
//            if tabBarController.isSelected(.second) {
//                tabBarController.select(.first)
//            } else {
//                tabBarController.selectSecond()
//            }
//        }
        tabBarController?.isSelected(.second) == true ? tabBarController?.select(.first) : tabBarController?.select(.second)
    }
}
