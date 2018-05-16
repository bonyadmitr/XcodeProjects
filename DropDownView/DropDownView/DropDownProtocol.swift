//
//  DropDownProtocol.swift
//  DropDownView
//
//  Created by Bondar Yaroslav on 20/11/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

typealias DropOption = String

protocol DropDownProtocol: class {
    var dropDownView: DropDownView { get }
    var maxDropDownHeight: CGFloat { get }
    var options: [DropOption] { get set }
    var height: NSLayoutConstraint { get set }
    var isOpen: Bool { get set }
    func dropDownView(_ dropDownView: DropDownView, didSelect option: DropOption, at index: Int)
}

extension DropDownProtocol where Self: UIView {
    var maxDropDownHeight: CGFloat {
        return 150
    }
    func addDropDownView() {
        //        insertSubview(dropDownView, at: 0)
        //        addSubview(dropDownView)
        //        bringSubview(toFront: dropDownView)
        
        self.superview?.addSubview(dropDownView)
        self.superview?.bringSubview(toFront: dropDownView)
        
        dropDownView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dropDownView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dropDownView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        height = dropDownView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    func setupDropDown() {
        dropDownView.delegate = self
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var options: [DropOption] {
        get {
            return dropDownView.options
        }
        set {
            dropDownView.options = newValue
        }
    }
    
    func openDropDown() {
        isOpen = true
        NSLayoutConstraint.deactivate([height])
        
        if dropDownView.contentHeight > maxDropDownHeight {
            height.constant = maxDropDownHeight
        } else {
            height.constant = dropDownView.contentHeight
        }
        NSLayoutConstraint.activate([height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropDownView.layoutIfNeeded()
            self.dropDownView.center.y += self.dropDownView.frame.height / 2
        }, completion: nil)
    }
    func closeDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([height])
        height.constant = 0
        NSLayoutConstraint.activate([height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropDownView.center.y -= self.dropDownView.frame.height / 2
            self.dropDownView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func toggleDropDown() {
        isOpen ? closeDropDown() : openDropDown()
    }
}
