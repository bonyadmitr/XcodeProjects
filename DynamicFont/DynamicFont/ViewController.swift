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
        
    }


}

