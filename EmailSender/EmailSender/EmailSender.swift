//
//  EmailSender.swift
//  EmailSender
//
//  Created by Bondar Yaroslav on 06/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import MessageUI

public typealias VoidHandler = () -> Void
public typealias EmailSenderCompletionStatusHandler = (EmailSenderCompletionStatus) -> Void

public struct MailAttachment {
    let data: Data
    let mimeType: String
    let fileName: String
}

public enum EmailSenderCompletionStatus {
    case sent
    case saved
    case cancelled
    case failed(Error)
}

/// You can customize the appearance of the interface using the UIAppearance protocol
open class EmailSender: NSObject {
    
    public static let shared = EmailSender()
    
    /// open Mail app with filled fields
    /// will not be open on simulator
    open func sendFromMailApp(message: String, subject: String? = nil, to emails: [String]) {
        
        let emailsString = emails.joined(separator: ",")
        var mailto = "mailto:\(emailsString)?"
        if let subject = subject {
           mailto += "subject=\(subject)&"
        }
        mailto += "body=\(message)"
        
        /// #2
        /// https://stackoverflow.com/a/54267099/5893286
        /// let coded = "mailto:\(email)?subject=\(subject)&body=\(bodyText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let coded = mailto.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        UIApplication.shared.open(scheme: coded)
    }
    
    fileprivate var completion: EmailSenderCompletionStatusHandler?
    
    /// open MFMailComposeViewController with filled fields
    /// faild on simulator with 'viewServiceDidTerminateWithError: Error'
    ///
    /// not possible to show keyboard when mail composer opens (tried subviews)
    /// https://stackoverflow.com/a/5074882/5893286
    open func send(message: String,
                   subject: String? = nil,
                   to emails: [String],
                   attachments: [MailAttachment]? = nil,
                   presentIn vc: UIViewController,
                   completion: EmailSenderCompletionStatusHandler? = nil) {
        
        guard MFMailComposeViewController.canSendMail() else {
            return UIApplication.shared.openMailApp()
        }
        self.completion = completion
        let mailVC = getMailVC(with: message, subject: subject, attachments: attachments, for: emails)
        vc.present(mailVC, animated: true, completion: nil)
    }
    
    /// not recommened to open MFMailComposeViewController with empty body bcz users can send a lot of empty mails.
    /// preferd open mail app or create pre-mail screen to fill MFMailComposeViewController
    ///
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

        controller.dismiss(animated: true) {
            let status: EmailSenderCompletionStatus
            switch result {
            case .cancelled:
                status = .cancelled
            case .saved:
                status = .saved
            case .sent:
                status = .sent
            case .failed:
                if let error = error {
                    status = .failed(error)
                } else {
                    /// localizedDescription: "The requested operation couldn’t be completed because the feature is not supported."
                    /// localized example ru: "Операцию не удалось завершить, так как эта функция не поддерживается."
                    /// use only NSCocoaErrorDomain. others ones will give interger error that are not good for users
                    let unknownError = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: nil)
                    status = .failed(unknownError)
                }
                
            } 
            self.completion?(status)
        }
    }
}
