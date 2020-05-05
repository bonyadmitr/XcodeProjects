//
//  ViewController.swift
//  DynamicFont
//
//  Created by Bondar Yaroslav on 5/4/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIFont {
    
    func dynamic() -> UIFont {
        return UIFontMetrics.default.scaledFont(for: self)
    }
    
    func dynamic(for textStyle: UIFont.TextStyle) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: self)
    }
}

extension UILabel {
    
    func setDynamicFont(font: UIFont, for textStyle: UIFont.TextStyle = .body) {
        self.font = font.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
    }
    
}

extension UITextField {
    
    func setDynamicFont(font: UIFont, for textStyle: UIFont.TextStyle = .body) {
        self.font = font.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
    }
    
    func updateFontToDynamic(for textStyle: UIFont.TextStyle = .body) {
        font = font?.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
        
        // TODO: check
        //adjustsFontSizeToFitWidth = false
    }
}

extension UITextView {
    func setDynamicFont(font: UIFont, for textStyle: UIFont.TextStyle = .body) {
        self.font = font.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //let font = UIFont.systemFont(ofSize: 30)
        //let font = UIFont.preferredFont(forTextStyle: .body)
        
        let font = UIFont.systemFont(ofSize: 30).dynamic()
        
        let label1 = UILabel()
        label1.text = "Label 1"
        label1.font = font
        label1.adjustsFontForContentSizeCategory = true
        
        let button1 = UIButton(type: .system)
        button1.setTitle("Button 1", for: .normal)
        button1.setTitleColor(.label, for: .normal)
        button1.titleLabel?.font = font
        button1.titleLabel?.adjustsFontForContentSizeCategory = true
        
        
        let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.red,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .font: font]
        let attrTitle = NSMutableAttributedString(string: "Button 2", attributes: attributes)
        
        let button2 = UIButton(type: .system)
        
        //button2.setTitleColor(.label, for: .normal)
        button2.setAttributedTitle(attrTitle, for: .normal)
        button2.titleLabel?.attributedText = attrTitle
        button2.titleLabel?.font = font
        button2.titleLabel?.adjustsFontForContentSizeCategory = true
        button2.setDynamicFontSize()
        
        view.addSubview(button2)
        button2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            button2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            button2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
        ])
        
    }


}

