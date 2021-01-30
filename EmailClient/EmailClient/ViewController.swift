//
//  ViewController.swift
//  EmailClient
//
//  Created by Yaroslav Bondr on 28.01.2021.
//

import UIKit


/**
 imap to get emails
 smtp to send email
 
 yandex IMAP setup https://yandex.ru/support/mail/mail-clients/apple-mail.html
 yandex auth problem "This user does not have access rights to this service" https://prnt.sc/uz30rb and https://searchengines.guru/ru/forum/1037543
 yandex lite client https://mail.yandex.ru/lite/inbox
 
 MailCore 2 lib
 http://libmailcore.com/api/objc/index.html
 https://github.com/MailCore/mailcore2
 https://github.com/MailCore/mailcore2/wiki
 setup https://stackoverflow.com/a/54954919/5893286
 setup video https://www.youtube.com/watch?v=NkpLqNN8xtU
 
 andoid lib
 https://eclipse-ee4j.github.io/mail/
 
 
 https://stackoverflow.com/a/31540230/5893286
 */

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

final class MailCoreManager {
    
    static let shared = MailCoreManager()
    
    private let imapSession = MCOIMAPSession()
    private let smtpSession = MCOSMTPSession()
    //    private var smtpSession: MCOSMTPSession?
    
    
    func login() {
        
        
        let domain = "yandex.ru"
        
        
        
        smtpSession.hostname = "smtp.\(domain)"
        smtpSession.username = username
        smtpSession.password = password
        smtpSession.port = 465
        smtpSession.authType = .saslPlain
        smtpSession.connectionType = .TLS
        smtpSession.timeout = 2
        smtpSession.isCheckCertificateEnabled = false
        
        
        
    }
}
