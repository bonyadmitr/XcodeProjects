//
//  ViewController.swift
//  JsonDecoding
//
//  Created by Yaroslav Bondr on 05.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension Mirror {
    
    /// The children of the mirror and its superclasses.
    var allChildren: [Mirror.Child] {
        var children = [Mirror.Child]()// = Array(self.children)
        
        var superclassMirror = self.superclassMirror
        
        while let mirror = superclassMirror {
            children.append(contentsOf: mirror.children)
            superclassMirror = mirror.superclassMirror
        }
        /// to display parant class properties first
        children.append(contentsOf: self.children)
        
        return children
    }
    
}
