//
//  ViewController.swift
//  OCRManager
//
//  Created by Bondar Yaroslav on 4/15/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let documentScanner = DocumentScanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        documentScanner.open(in: self) { images in
            for image in images {
                OCRManager().scan(image: image) { ocrText in
                    print(ocrText)
                }
            }
        }
    }

}
