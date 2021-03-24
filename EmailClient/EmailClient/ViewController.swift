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
 yandex auth problem "Error: authentication failed: This user does not have access rights to this service" https://prnt.sc/uz30rb and https://searchengines.guru/ru/forum/1037543
 yandex lite client https://mail.yandex.ru/lite/inbox
 
 MailCore 2 lib
 inside MailCore https://github.com/dinhvh/libetpan
 classes http://libmailcore.com/api/objc/index.html
 source https://github.com/MailCore/mailcore2
 wiki https://github.com/MailCore/mailcore2/wiki
 setup https://stackoverflow.com/a/54954919/5893286
 setup video https://www.youtube.com/watch?v=NkpLqNN8xtU
 
 andoid lib
 https://eclipse-ee4j.github.io/mail/
 
 
 https://stackoverflow.com/a/31540230/5893286
 
 В клиентах перемещение реализовано через копирование+удаление
 https://habr.com/ru/company/mailru/blog/151001/
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
    
    func fetchFolderStatus(folder: String, handler: @escaping (Result<MCOIMAPFolderStatus, Error>) -> Void) {
        
        imapSession.folderStatusOperation(folder).start { error, result in
            if let error = error {
                handler(.failure(error))
            } else if let result = result {
                handler(.success(result))
            } else {
                assertionFailure()
                // TODO: unknown error
                handler(.failure(NSError()))
            }
        }
    }
    func fetchFolderInfo(folder: String, handler: @escaping (Result<MCOIMAPFolderInfo, Error>) -> Void) {
        imapSession.folderInfoOperation(folder).start { error, result in
            if let error = error {
                handler(.failure(error))
            } else if let result = result {
                handler(.success(result))
            } else {
                assertionFailure()
                // TODO: unknown error
                handler(.failure(NSError()))
            }
        }
    }

/// inspired https://stackoverflow.com/a/50272973/5893286
func ~= (pattern: MCOIMAPFolderFlag, value: MCOIMAPFolderFlag) -> Bool {
    return value.contains(pattern)
}




/**
 письмо всегда с новым uid. а сортировка по дате
 получается отображать мы можешь только когда выкачали все
 получается новые письма мы всегда получим относительно локального самого последнего uid
 
 --------
 - folder status: <mailcore::IMAPFolderStatus:0x600002ff8480 msg_count: 3, unseen_count: 0, recent_count: 0, uid_next: 21, uid_validity: 1, highestmodseqvalue :2880>
 ++++++++ all:
 8 - 2021-02-02 07:10:45 +0000
 19 - 2021-02-02 07:25:09 +0000
 20 - 2021-02-02 10:11:35 +0000
 --------
 - folder status: <mailcore::IMAPFolderStatus:0x600002f0c990 msg_count: 2, unseen_count: 0, recent_count: 0, uid_next: 21, uid_validity: 1, highestmodseqvalue :2908>
 ++++++++ all:
 19 - 2021-02-02 07:25:09 +0000
 20 - 2021-02-02 10:11:35 +0000
 --------
 - folder status: <mailcore::IMAPFolderStatus:0x600002ffef70 msg_count: 3, unseen_count: 0, recent_count: 0, uid_next: 22, uid_validity: 1, highestmodseqvalue :2934>
 ++++++++ all:
 19 - 2021-02-02 07:25:09 +0000
 20 - 2021-02-02 10:11:35 +0000
 21 - 2021-02-02 07:10:45 +0000
 --------
 */


/// https://github.com/mattcomi/ReflectedStringConvertible/blob/master/ReflectedStringConvertible/ReflectedStringConvertible.swift
protocol ReflectedStringConvertible : CustomStringConvertible { }

extension ReflectedStringConvertible {
    
    
    
    var description: String {
        desc
    }
    
    var desc: String {
        if let nsSelf = self as? NSObject, let type = Self.self as? AnyClass {
            return nsSelf.desc(from: type)
        }
        
        let mirror = Mirror(reflecting: self)
        
        let descriptions: [String] = mirror.allChildren.compactMap { (label: String?, value: Any) in
            if let label = label {
                var value = value
                if value is String {
                    value = "\"\(value)\""
                }
                return "\(label): \(value)"
            }
            
            return nil
        }
        
        return "\(mirror.subjectType)(\(descriptions.joined(separator: ", ")))"
    }
    
}

extension NSObject {
    
    
    
    /// source https://stackoverflow.com/a/46611354/5893286
    func toDictionary(from classType: AnyClass) -> [String: Any] {
        
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass = class_copyPropertyList(classType, &propertiesCount)
        var propertiesDictionary = [String:Any]()
        
        for i in 0 ..< Int(propertiesCount) {
            if let property = propertiesInAClass?[i],
               let strKey = NSString(utf8String: property_getName(property)) as String? {
                propertiesDictionary[strKey] = value(forKey: strKey)
            }
        }
        return propertiesDictionary
    }
    
    var desc2: String {
        desc(from: Self.self)
    }
    
    func desc(from classType: AnyClass) -> String {
        
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass = class_copyPropertyList(classType, &propertiesCount)
        var result = String(describing: classType) + " {"
        
        for i in 0 ..< Int(propertiesCount) {
            if let property = propertiesInAClass?[i],
               let strKey = NSString(utf8String: property_getName(property)) as String?
            {
                result += "\n\t\(strKey): \(value(forKey: strKey) ?? "nil")"
            }
        }
        return result + "\n}"
    }
    
}


extension Mirror {
    
    /// The children of the mirror and its superclasses.
    var allChildren: [Mirror.Child] {
        var children = [Mirror.Child]()// = Array(self.children)
        
        var superclassMirror = self.superclassMirror
        
        while let mirror = superclassMirror {
            children.append(contentsOf: mirror.children)
            superclassMirror = mirror.superclassMirror
        }
        /// to display parant class properties first
        children.append(contentsOf: self.children)
        
        return children
    }
    
}
