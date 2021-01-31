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
        
        print("started")
        MailCoreManager.shared.login()
        generalAction()
    }
    
    @IBAction private func onSend(_ sender: UIButton) {
        generalAction()
    }
    
    private func generalAction() {
        //MailCoreManager.shared.send()
        
//        MailCoreManager.shared.fetchFolderStatus(folder: "INBOX") { result in
//            switch result {
//            case .success(let status):
//                print("- folder status: \(status)")
//                print()
//            case .failure(let error):
//                print(error.localizedDescription)
//                print()
//            }
//        }
//
//        MailCoreManager.shared.fetchFolderInfo(folder: "INBOX") { result in
//            switch result {
//            case .success(let info):
//                print("- folder info: \(info.modSequenceValue)")
//                print()
//            case .failure(let error):
//                print(error.localizedDescription)
//                print()
//            }
//        }
        
        MailCoreManager.shared.fetchEmails(for: "INBOX") { result in

        }

        
        MailCoreManager.shared.syncMessagesByUIDWithFolder(folder: "INBOX") { result in

        }
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
        
        // TODO: check google
//        smtpSession.hostname = "smtp.gmail.com"
//        smtpSession.username = "matt@gmail.com"
//        smtpSession.password = "xxxxxxxxxxxxxxxx"
//        smtpSession.port = 465
//        smtpSession.authType = .saslPlain
//        smtpSession.connectionType = .TLS
        
        
        
//        smtpSession.connectionLogger = { (connectionID, type, data) in
//            if let data = data, let string = String(data: data, encoding: .utf8){
//                print("- smtp log: \(string)")
//            } else {
//                assertionFailure()
//            }
//        }
        
        
        imapSession.username = username
        imapSession.password = password
        imapSession.hostname = "imap.\(domain)"
        imapSession.port = 993
        imapSession.connectionType = .TLS
        imapSession.timeout = 2
//        imapSession.connectionLogger  = { (connectionID, type, data) in
//            if let data = data, let string = String(data: data, encoding: .utf8){
//                print("- imap log: \(string)")
//            } else {
//                print("- imap log error: \(type.rawValue) \(data?.count ?? -1)")
//            }
//        }
        
        
        
        smtpSession.loginOperation()?.start({ (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success smtpSession")
            }
        })
        
        
        // TODO: sync login
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//
        imapSession.checkAccountOperation()?.start({ (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success imapSession")
            }
        })
        
//        fetchAllFolder { result in
//            switch result {
//            case .success(let folders):
//                /// INBOX in yandex `folders[1].path`
//                print(folders)
//                print()
//            case .failure(let error):
//                print(error.localizedDescription)
//                print()
//            }
//        }
        
        fetchFolderStatus(folder: "INBOX") { result in
            switch result {
            case .success(let status):
                print("- folder status: \(status)")
                print()
            case .failure(let error):
                print(error.localizedDescription)
                print()
            }
        }
        
//        fetchFolderInfo(folder: "INBOX") { result in
//            switch result {
//            case .success(let info):
//                print("- folder info: \(info)")
//                print()
//            case .failure(let error):
//                print(error.localizedDescription)
//                print()
//            }
//        }
        
//        fetchEmails(for: "INBOX") { result in
//            switch result {
//            case .success(let emails):
//                print(emails)
//                //MCOIMAPMessage().modSeqValue
//                print()
//            case .failure(let error):
//
//                /// 123 FETCH
//                /// /// - imap log error: 4 -1
//                /// Error Domain=MCOErrorDomain Code=1 "A stable connection to the server could not be established." UserInfo={NSLocalizedDescription=A stable connection to the server could not be established.}
//
//                print(error.localizedDescription)
//                print()
//            }
//        }
        
        
    }
    
    func fetchAllFolder(handler: @escaping (Result<[MCOIMAPFolder], Error>) -> Void) {
        imapSession.fetchAllFoldersOperation().start { (error, result) -> Void in
            if let error = error {
                handler(.failure(error))
            } else if let result = result as? [MCOIMAPFolder] {
                handler(.success(result))
            } else {
                assertionFailure()
                // TODO: unknown error
                handler(.failure(NSError()))
            }
        }
    }
    }
}
