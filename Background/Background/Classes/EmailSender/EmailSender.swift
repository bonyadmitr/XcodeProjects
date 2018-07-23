//
//  EmailSender.swift
//  EmailSender
//
//  Created by Bondar Yaroslav on 06/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import MessageUI

public struct MailAttachment {
    let data: Data
    let mimeType: String
    let fileName: String
}

/// You can customize the appearance of the interface using the UIAppearance protocol
open class EmailSender: NSObject {
    
    open static let shared = EmailSender()
    
    /// open Mail app with filled fields
    /// will not be open on simulator
    open func sendFromMailApp(message: String, subject: String? = nil, to emails: [String]) {
        
        let emailsString = emails.joined(separator: ",")
        var mailto = "mailto:\(emailsString)?"
        if let subject = subject {
           mailto += "subject=\(subject)&"
        }
        mailto += "body=\(message)"
        
        guard let coded = mailto.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        UIApplication.shared.open(scheme: coded)
    }
    
    /// open MFMailComposeViewController with filled fields
    /// faild on simulator with 'viewServiceDidTerminateWithError: Error'
    open func send(message: String,
                   subject: String? = nil,
                   to emails: [String],
                   attachments: [MailAttachment]? = nil,
                   presentIn vc: UIViewController) {
        
        guard MFMailComposeViewController.canSendMail() else {
            return UIApplication.shared.openMailApp()
        }
        let mailVC = getMailVC(with: message, subject: subject, attachments: attachments, for: emails)
        vc.present(mailVC, animated: true, completion: nil)
    }
    
    /// get configured MFMailComposeViewController
    private func getMailVC(with message: String,
                           subject: String?,
                           attachments: [MailAttachment]?,
                           for emails: [String]) -> MFMailComposeViewController {
        
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        vc.setToRecipients(emails)
        vc.setMessageBody(message, isHTML: false)
        
        if let subject = subject {
            vc.setSubject(subject)
        }
        
        if let attachments = attachments {
            attachments.forEach { vc.addAttachmentData($0.data, mimeType: $0.mimeType, fileName: $0.fileName) }
        }
        
        return vc
    }
}

extension EmailSender: MFMailComposeViewControllerDelegate {
    
    /// Need for MFMailComposeViewController to enable cancel button
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
