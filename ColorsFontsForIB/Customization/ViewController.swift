//
//  ViewController.swift
//  Customization
//
//  Created by Bondar Yaroslav on 19/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fontNameLabel: UILabel!
    
    override func viewDidLoad() {
//        Images.background = nil //#imageLiteral(resourceName: "keyboard_icon")
        super.viewDidLoad()
        ///Example of code usage
        //UILabel().font = Fonts.base.font(with: 10)
        //UILabel().textColor = Colors.dark
    }
    
    @IBAction func backToVC(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navVC = segue.destination as? UINavigationController else { return }
        let vc = navVC.topViewController as! FontsController
        vc.delegate = self
        
        switch segue.identifier! {
        case "allFonts":
            vc.type = .all
        case "regularFonts":
            vc.type = .regular
        case "lightFonts":
            vc.type = .light
        case "boldFonts":
            vc.type = .bold
        default:
            break
        }

    }
}

extension ViewController: FontsControllerDelegate {
    func didSelectFont(fontName: String) {
        fontNameLabel.font = UIFont(name: fontName, size: 17)
        fontNameLabel.text = fontName
        updateAllLabeles(in: view, with: fontName)
        Fonts.setNames(base: fontName)
    }
    
    func updateAllLabeles(in view: UIView, with fontName: String) {
        view.subviews
            .execute { updateAllLabeles(in: $0, with: fontName) }
            .flatMap { $0 as? UILabel }
            .forEach { $0.font = UIFont(name: fontName, size: $0.font.pointSize) }
    }
}
