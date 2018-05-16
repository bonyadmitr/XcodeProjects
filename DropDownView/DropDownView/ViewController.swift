//
//  ViewController.swift
//  DropDownView
//
//  Created by Bondar Yaroslav on 19/11/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var button = DropDownButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = DropDownButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        button.setTitle("Colors", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //Add Button to the View Controller
        view.addSubview(button)
        
        //button Constraints
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Set the drop down menu's options
        button.options = ["Blue", "Green", "Magenta", "White", "Black", "Pink"]
    }
}

class DropDownTextField: UITextField, DropDownProtocol {
    let dropDownView = DropDownView()
    var isOpen = false
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
//        backgroundColor = UIColor.darkGray
        setupDropDown()
    }
    
    override func didMoveToSuperview() {
        addDropDownView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleDropDown()
    }
    
    func dropDownView(_ dropDownView: DropDownView, didSelect option: DropOption, at index: Int) {
        closeDropDown()
        print(option)
    }
}


class DropDownButton: UIButton, DropDownProtocol {
    
    let dropDownView = DropDownView()
    var isOpen = false
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.darkGray
        setupDropDown()
//        addDropDownView()
    }
    
    override func didMoveToSuperview() {
        addDropDownView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleDropDown()
    }
    
    func dropDownView(_ dropDownView: DropDownView, didSelect option: DropOption, at index: Int) {
        closeDropDown()
        print(option)
    }
}
