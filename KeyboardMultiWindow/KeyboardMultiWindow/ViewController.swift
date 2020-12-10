//
//  ViewController.swift
//  KeyboardMultiWindow
//
//  Created by Yaroslav Bondr on 08.12.2020.
//

import UIKit

var newWindow: UIWindow!

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
        
        
        
//        let currentWindow = UIApplication.shared.keyWindow
//
////        print(UIApplication.shared.windows.count)
//        for window in UIApplication.shared.windows where window.tag == 100 {
//            window.makeKeyAndVisible()
//            UIApplication.shared.sendAction(#selector(resignFirstResponder), to: window, from: nil, for: nil)
//        }
//        currentWindow?.makeKeyAndVisible()
//

    }
    
    @objc private func onButtonWindow() {
//        print(UIApplication.shared.windows.count)
        
        let vc = ViewController()
        vc.view.backgroundColor = .red
        
        let window: UIWindow
        if #available(iOS 13.0, *) {
            /// https://stackoverflow.com/a/59967726/5893286
            window = UIApplication.shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }
                .map { UIWindow(windowScene: $0) }!
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
//        window.backgroundColor = .cyan
//        window.windowLevel = .statusBar
        window.rootViewController = vc
        window.isHidden = false
//        window.makeKeyAndVisible()
        window.tag = 100
        newWindow = window
        
        onButton()
//        vc.textField.becomeFirstResponder()
        
//        print(UIApplication.shared.windows.count)
    }

}

final class WindowManager {
    
    static let shared = WindowManager()
    
    let window: UIWindow = {
        let window: UIWindow
        if #available(iOS 13.0, *) {
            /// https://stackoverflow.com/a/59967726/5893286
            window = UIApplication.shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }
                .map { UIWindow(windowScene: $0) }
                ?? UIWindow(frame: UIScreen.main.bounds)
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        return window
    }()
    
    func show() {
        window.makeKeyAndVisible()
        //window.isHidden = false
    }
    
    func hide() {
        //window.isKeyWindow
        window.isHidden = true
        
        //if #available(iOS 13, *) {
        //    window.windowScene = nil
        //}
        //window = nil
    }
    
}
