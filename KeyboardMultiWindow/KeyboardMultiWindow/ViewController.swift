//
//  ViewController.swift
//  KeyboardMultiWindow
//
//  Created by Yaroslav Bondr on 08.12.2020.
//

import UIKit

class ViewController: UIViewController {

    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textField.borderStyle = .roundedRect
        
        let button1 = UIButton(type: .system)
        button1.addTarget(self, action: #selector(onButtonWindow), for: .touchUpInside)
        button1.setTitle("window", for: .normal)
        
        let button2 = UIButton(type: .system)
        button2.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        button2.setTitle("Hide", for: .normal)
        
        
        
        let stackView = UIStackView(arrangedSubviews: [textField, button1, button2])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            //stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
        
    }

    @objc private func onButton() {
//        if newWindow?.isKeyWindow == true {
//            newWindow.isHidden = true
//            if #available(iOS 13, *) {
//                newWindow.windowScene = nil
//            }
//            newWindow = nil
////            globalWindow.makeKeyAndVisible()
//        }
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        
        
//        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
//        keyWindow?.endEditing(true)
        
//        UIApplication.shared.windows.forEach { $0.endEditing(true) }
//        UIApplication.shared.delegate?.window??.endEditing(true)
        

    }
    

}

