//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by Константин on 12.10.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVFoundation

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width / 2)
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        
        self.titleLabel.text = content.title
        self.bodyLabel.text = content.body
        
        guard let attachment = notification.request.content.attachments.first else { return }
        
        if attachment.url.startAccessingSecurityScopedResource() {
            let imageData = try? Data.init(contentsOf: attachment.url)
            if let imageData = imageData {
                imageView.image = UIImage(data: imageData)
            }
        }
        attachment.url.stopAccessingSecurityScopedResource()
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == "play_action" {
            do {
                try self.player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "play", ofType: "m4a")!))
                self.player?.play()
            } catch {
                print("prepare player error!")
            }
            completion(.doNotDismiss)
        } else if response.actionIdentifier == "print_action" {
            self.bodyLabel.text = "Print Text Success"
            completion(.doNotDismiss)
        } else if response.actionIdentifier == "comment_action" {
            
            let res = response as! UNTextInputNotificationResponse
            self.titleLabel.text = res.userText
            completion(.doNotDismiss)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.player?.stop()
            self.player = nil
        }
    }

}







