//
//  DetailViewController.swift
//  ViperApp-Mac
//
//  Created by Bondar Yaroslav on 03/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import ViperKit
import DipUI

class DetailViewController: NSViewController, ModuleInputProvider {
    var output: DetailViewOutput!
    var moduleInput: ModuleInput!
    
    private var post: Post?
    
    @IBOutlet private weak var titleLabel: NSTextField!
    @IBOutlet private weak var idLabel: NSTextField!
    @IBOutlet private weak var userIdLabel: NSTextField!
    @IBOutlet private weak var bodyLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        if let post = self.post {
            post.title = "!!! " + post.title
            output.viewWillDisappear(with: post)
        }
    }
    
    private func fill(with post: Post) {
        titleLabel.stringValue = post.title
        idLabel.stringValue = "ID: \(post.id)"
        userIdLabel.stringValue = "UserID: \(post.userId)"
        bodyLabel.stringValue = post.body
    }
}

extension DetailViewController: StoryboardInstantiatable {}

extension DetailViewController: TransitionHandler {
    func openModule(segueIdentifier: String) {
        
    }
    
    func openModule(segueIdentifier: String, configurationBlock: @escaping ConfigurationBlock) {
        
    }
    
    func closeCurrentModule() {
        
    }
}

extension DetailViewController: DetailViewInput {
    func set(post: Post) {
        self.post = post.copy()
    }
    
    func setupInitialState() {
        if let post = self.post {
            fill(with: post)
            title = "ID: \(post.id)"
        }
    }
    
    func show(error: Error) {
        print(error.localizedDescription)
    }
}
