//
//  ViewController.swift
//  SpotifyApiTest
//
//  Created by Bondar Yaroslav on 9/25/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = SpotifyWebViewAuthController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

}

extension ViewController: SpotifyWebViewAuthControllerDelegate {
    func spotifyAuthSuccess(with spotifyCode: String) {
        print("success with code: \(spotifyCode)")
        
        /// close SpotifyWebViewAuthController
        assert(presentedViewController is SpotifyWebViewAuthController)
        dismiss(animated: true, completion: nil)
    }
    
    func spotifyAuthCancel() {
        
    }
    
}
