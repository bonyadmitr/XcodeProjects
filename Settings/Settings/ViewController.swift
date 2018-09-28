//
//  ViewController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        /// if you set title in viewDidLoad(loadView too), it will not be set in language changing
        title = "language".localized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

final class SampleDesigner: NSObject {
    @IBOutlet private weak var sampleLabel: UILabel! {
        willSet {
            newValue.text = "language".localized
        }
    }
}
