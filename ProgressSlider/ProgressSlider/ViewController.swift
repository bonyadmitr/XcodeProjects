//
//  ViewController.swift
//  ProgressSlider
//
//  Created by Bondar Yaroslav on 21/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        progressSlider.
    }
}

final class ProgressSlider: UISlider {
    
    var progress: Float {
        get { return progressView.progress }
        set { progressView.progress = newValue }
    }
    
    private var progressView: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        progressView = UIProgressView()
        addSubview(progressView)
        progressView.isUserInteractionEnabled = false
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.topAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        progressView.progressTintColor = UIColor.red
        progressView.trackTintColor = UIColor.lightGray
        progressView.progress = 0.2
        
        minimumTrackTintColor = UIColor.clear
        maximumTrackTintColor = UIColor.clear
    }
}
