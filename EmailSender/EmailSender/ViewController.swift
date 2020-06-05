//
//  ViewController.swift
//  EmailSender
//
//  Created by Bondar Yaroslav on 06/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

@dynamicMemberLookup
struct Template {
    var template: String = ""
    private var data : [String:String] = [:]
    var populatedTemplate : String { data.reduce(template) { $0.replacingOccurrences(of: "${\($1.key)}", with: $1.value) } }
    
    subscript (dynamicMember member: String) -> CustomStringConvertible? {
        get { data[member] }
        set { data[member] = newValue?.description }
    }
}

class ViewController: UIViewController {

    let message = "Hello привет world" // can be ""
    let subject: String? = "Some sobject" // can be nil
    let emails: [String] = ["qweqwe@gmail.com", "dwqeweqweq@gmail.com"] // can be []
    
    
    @IBAction func actionSendInAppButton(_ sender: UIButton) {
        EmailSender.shared.send(message: message,
                                subject: subject,
                                to: emails,
                                presentIn: self)
    }
    
    @IBAction func actionSendFromMailButton(_ sender: UIButton) {
        EmailSender.shared.sendFromMailApp(message: message,
                                           subject: subject,
                                           to: emails)
    }
    let phones: [String] = ["+11231", "euwewejhfh"] // can be []
    @IBAction func actionSendSMSInAppButton(_ sender: UIButton) {
        SMSSender.shared.send(message: message, to: phones)
    }
    
    @IBAction func actionSendSMSFromSMSAppButton(_ sender: UIButton) {
        SMSSender.shared.sendFromSMSApp(message: message, to: phones)
    }
}
