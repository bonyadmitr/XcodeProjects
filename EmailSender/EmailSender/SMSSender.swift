//
//  SMSSender.swift
//  EmailSender
//
//  Created by Bondar Yaroslav on 06/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import MessageUI

open class SMSSender: NSObject {
    
    open static let shared = SMSSender()
    
    open func sendFromSMSApp(message: String, to phones: [String]) {
        
        let phonesString = phones.joined(separator: ",")
        let smsto = "sms:\(phonesString)&body=\(message)"
        
        guard let coded = smsto.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        UIApplication.shared.open(scheme: coded)
    }
    
    open func send(message: String,
              to phones: [String],
              presentIn vc: UIViewController? = UIApplication.topViewController()) {
        
        guard let vc = vc, MFMessageComposeViewController.canSendText() else {
            return print("Can't send sms")
        }
        let mailVC = getMessageVC(with: message, for: phones)
        vc.present(mailVC, animated: true, completion: nil)
    }
    
    private func getMessageVC(with message: String,
                              for phones: [String]) -> MFMessageComposeViewController {
        
        let vc = MFMessageComposeViewController()
        vc.body = message
        vc.recipients = phones
        vc.messageComposeDelegate = self
        return vc
    }
}

/// Need for MFMessageComposeViewController to enable cancel button
extension SMSSender: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
