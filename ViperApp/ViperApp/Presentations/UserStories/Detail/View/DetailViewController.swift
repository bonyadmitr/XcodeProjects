//
//  DetailViewController.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 28/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipUI
import ViperKit

final class DetailViewController: ViperController, StoryboardInstantiatable {
    var output: DetailViewOutput!

    @IBOutlet private weak var postView: PostView!
    private var post: Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let post = self.post {
            post.title = "!!! " + post.title
            output.viewWillDisappear(with: post)
        }
    }
    
    deinit {
        print("- DetailViewController")
    }
}

// MARK: - View Input
extension DetailViewController: DetailViewInput {
    func setupInitialState() {
        if let post = self.post {
            postView.fill(with: post)
        }
    }
    
    func set(post: Post) {
        self.post = post.copy()
    }

    func show(error: Error) {
        UIAlertController(errorMessage: error.localizedDescription).show()
    }
}
