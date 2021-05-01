//
//  ViewController.swift
//  EmailClient
//
//  Created by Yaroslav Bondr on 28.01.2021.
//

import UIKit

// TODO: check
/// Swift SMTP client https://github.com/Kitura/Swift-SMTP with Inspired https://github.com/onevcat/Hedwig and https://github.com/PerfectlySoft/Perfect-SMTP
/// Postal - MailCore2 swift simple analog  https://github.com/snipsco/Postal
/**
 imap to get emails
 smtp to send email
 
 yandex IMAP setup https://yandex.ru/support/mail/mail-clients/apple-mail.html
 yandex auth problem "Error: authentication failed: This user does not have access rights to this service" https://prnt.sc/uz30rb and https://searchengines.guru/ru/forum/1037543
 yandex lite client https://mail.yandex.ru/lite/inbox
 
 MailCore2 lib
 inside MailCore https://github.com/dinhvh/libetpan
 classes http://libmailcore.com/api/objc/index.html
 source https://github.com/MailCore/mailcore2
 wiki https://github.com/MailCore/mailcore2/wiki
 setup https://stackoverflow.com/a/54954919/5893286
 setup video https://www.youtube.com/watch?v=NkpLqNN8xtU
 
 andoid lib
 https://eclipse-ee4j.github.io/mail/
 
 send basic example https://stackoverflow.com/a/31540230/5893286
 
 В клиентах перемещение реализовано через копирование+удаление
 https://habr.com/ru/company/mailru/blog/151001/
 */

//https://ru.wikipedia.org/wiki/SMTP
//https://ru.wikipedia.org/wiki/%D0%97%D0%B0%D0%BF%D0%B8%D1%81%D1%8C_MX
//https://ru.wikipedia.org/wiki/%D0%A1%D0%B5%D1%80%D1%8B%D0%B9_%D1%81%D0%BF%D0%B8%D1%81%D0%BE%D0%BA

/**
 mail server setup https://m.habr.com/ru/post/544376/
 
 SMTP используется для приема входящей и исходящей почты с/на другие почтовые серверы. И это позволяет пользователям домена отправлять свои сообщения.

 25 порт
 Этот порт необходим для управления входящими подключениями от других почтовых серверов. Метод безопасности следует установить в STARTTLS.

 587 порт
 Он нужен для почтовых клиентов собственного почтового сервера. Метод безопасности следует установить в STARTTLS.

 465 порт
 Он не является официальным и может потребоваться для старых почтовых клиентов. И метод безопасности следует установить в SSL/TLS.

 POP3, IMAP
 POP3 и IMAP используются отдельными почтовыми клиентами, такими как Outlook на ПК или любой почтовый клиент на мобильных телефонах. Это позволяет пользователям домена управлять своими сообщениями.

 Порт 993 следует использовать для защищенных соединений IMAP, а порт 995 - для POP3. Для обеспечения совместимости с большинством клиентов метод безопасности следует установить в SSL/TLS (не STARTTLS).

 Также можно настроить порты 143 для IMAP и 110 для POP3, но они не шифруются и сейчас их уже мало кто использует.
 
 
 ----------
 Существует множество онлайн-сервисов, которые могут проверять отправку электронной почты. Ниже приведены некоторые из них.
 
 AppMailDev https://www.appmaildev.com/
 Этот сервис позволяет тестировать конфигурацию почтового сервера, такую как DKIM и SPF, отправляя электронное письмо на указанный сгенерированный почтовый адрес. Нужно просто следовать инструкциям на экране и результаты теста будут отображены там же.

 DKIMValidator https://dkimvalidator.com/
 Предоставляет те же функции, что и предыдущая служба. Результаты тестирования будут отправлены на адрес отправителя.

 HAD Email Auth Tester https://email-test.had.dnsops.gov/
 Чтобы проверить отправку сообщения здесь, нужно отправить специальное сообщение на tester@email-test.had.dnsops.gov. Результаты тестирования будут отправлены на адрес отправителя.

 PowerDMARC https://powerdmarc.com/power-dmarc-toolbox
 Этот сервис предоставляет только облегченную проверку всех атрибутов, но у него есть удобные инструменты, указанные в ссылках выше.
 */


final class DataSource {
    
    
    static let shared = DataSource()
    
    var uidNext: UInt32 = 0
    var uidValidity: UInt32 = 0
    var highestModSeqValue: UInt64 = 0
    var emails = [MCOIMAPMessage]()
    
}


// TODO: check
//https://stackoverflow.com/questions/21096218/fetching-gmails-via-mailcore-2-thread-id-vs-message-id-vs-uid
//https://stackoverflow.com/questions/tagged/mailcore2


// TODO: If x mail moved, its uid/folderName will be changed
// And if there are other transactions related to this mail we fucked up


// TODO: mail detail
//old imapSession.fetchMessageByUIDOperation(withFolder: <#T##String!#>, uid: <#T##UInt32#>, urgent: <#T##Bool#>)
//imapSession.fetchMessageOperation(withFolder: <#T##String!#>, uid: <#T##UInt32#>)


// TODO: check
//https://github.com/MailCore/mailcore2/wiki/Providers-Syntax
//MCOMailProvidersManager.shared()?.provider(forEmail: "")?.allMailFolderPath()
//MCOMailProvidersManager.shared()?.registerProviders(withFilename: "")
// TODO: https://github.com/MailCore/mailcore2/blob/master/resources/providers.json


/// possible error `CFNetwork SSLHandshake failed (-9847)`. it is wrong connection settings like port. no need to edit info.plist for NSAppTransportSecurity



//let array = Array(repeating: 1, count: 9)
//var page = 0
//let limit = 2
//print()
//array.chunked(into: limit)
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        struct QQQ {
//            let title: String
//            let body: String?
//        }
//
//        let array = [QQQ(title: "1", body: "b1"), QQQ(title: "1", body: "b1")]
//
//        let isSameTitle = array.isPropertiesEquals(by: \.body)
//        print("isSameTitle: \(isSameTitle)")
        //assert(array.isPropertiesEquals(by: \.title))
        

        MailCoreManager.shared.login()
//        generalAction()
    }
    
    @IBAction private func onSend(_ sender: UIButton) {
        generalAction()
    }
    
    private func generalAction() {
//        MailCoreManager.shared.folders()
        
//        MailCoreManager.shared.send()
        
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

//        return
//        return

//        MailCoreManager.shared.fetchFolderInfo(folder: "INBOX") { result in
//            switch result {
//            case .success(let info):
//                print("- folder info: \(info.desc)")
//                print()
//            case .failure(let error):
//                print(error.localizedDescription)
//                print()
//            }
//        }
        
        
    }

}


final class MailCoreManager {
    
    static let shared = MailCoreManager()
    
    let imapSession = MCOIMAPSession()
    let smtpSession = MCOSMTPSession()
    //    private var smtpSession: MCOSMTPSession?
    
    
    func login() {
        //let domain = "yandex.ru"
//        let domain = "yaanimail.com"
        let domain = username.split(separator: "@").last!
        
        /**
         gmail setup https://support.google.com/mail/answer/7126229?hl=ru
         
         Заблокировано небезопасное приложение
         Это приложение заблокировано, поскольку оно не соответствует стандартам безопасности Google.
         Некоторые приложения и устройства используют ненадежные технологии входа, которые могут подвергнуть угрозе ваш аккаунт. Мы рекомендуем запретить доступ таким приложениям и устройствам. Если вы хотите работать с ними, несмотря на риск, разрешите доступ. Google автоматически отключит эту функцию, если она не будет использоваться.
         
         https://myaccount.google.com/u/2/security?nlr=1
         Ненадежные приложения, у которых есть доступ к аккаунту
         */
        
        let isYaani = (domain == "yaani.com")
        let isLife = (domain == "life.com.by")
        let isOutlook = (domain == "outlook.com")
        // need to turn on IMAP: https://mail.yaani.com/settings/synch or web page -> account settings -> Synchronization tab
        //IMAP server: imap.yaanimail.com – port 993 – SSL
        //SMTP server: smtp.yaanimail.com – port 587 – TLS
        //POP3 server: pop.yaanimail.com – port 995 – SSL
        
        // possible 25, 465, 587
        if isYaani {
            smtpSession.hostname = "smtp.yaanimail.com"
            smtpSession.port = 587
            smtpSession.connectionType = .startTLS
            smtpSession.authType = .saslLogin //or .saslPlain
        } else if isLife {
            // The server does not support STARTTLS connections
            smtpSession.hostname = "mx01.life.com.by"
            smtpSession.port = 25
            smtpSession.connectionType = .clear
            //AUTH PLAIN eWFyb3NsYXYuYm9uZGFyQGxpZmUuY29tLmJ5AHlhcm9zbGF2LmJvbmRhckBsaWZlLmNvbS5ieQBRZGFjZXpxYzEyMzQ1
            //504 5.7.4 Unrecognized authentication type
            //
            //Unable to authenticate with the current session's credentials
            //https://stackoverflow.com/a/31942248/5893286
            smtpSession.authType = .saslPlain
        } else if isOutlook {
            // https://support.microsoft.com/en-us/office/pop-imap-and-stmp-settings-8361e398-8af4-4e97-b147-6c6c4ac95353
            smtpSession.hostname = "smtp-mail.outlook.com"
            smtpSession.port = 587
            smtpSession.connectionType = .startTLS
            smtpSession.authType = .saslLogin
        } else {
            // gmail, yandex
            smtpSession.hostname = "smtp.\(domain)"
            smtpSession.port = 587
            smtpSession.connectionType = .startTLS
            smtpSession.authType = .saslLogin
            
            // gmail, yandex
//            smtpSession.port = 465
//            smtpSession.connectionType = .TLS
//            smtpSession.authType = .saslPlain
        }
        
        smtpSession.username = username
        smtpSession.password = password
        smtpSession.timeout = 10 // 2 for most servers. min 4 for outlook
        smtpSession.isCheckCertificateEnabled = false
        
//        smtpSession.connectionLogger = { (connectionID, type, data) in
//            if let data = data, let string = String(data: data, encoding: .utf8){
//                print("- smtp log: \(string)")
//            } else {
//                print("- smtp error: \(type.rawValue)")
//            }
//        }
        
        smtpSession.loginOperation()?.start({ (error) in
            if let error = error {
                print("- smtp login error:", error)
            } else {
                print("success smtpSession")
            }
        })
        
        
        if isYaani {
            imapSession.hostname = "imap.yaanimail.com"
        /// it is from doc. but working without it
        //} else if isOutlook {
        //    imapSession.hostname = "imap-mail.outlook.com"
        } else {
            imapSession.hostname = "imap.\(domain)"
        }
        
        if isLife {
            /// fix error: The certificate for this server is invalid https://stackoverflow.com/a/19018196/5893286
            imapSession.isCheckCertificateEnabled = false
        }
        imapSession.port = 993
        
        imapSession.username = username
        imapSession.password = password
        imapSession.connectionType = .TLS
        imapSession.timeout = 2

        
//        imapSession.connectionLogger  = { (connectionID, type, data) in
//            if let data = data, let string = String(data: data, encoding: .utf8){
//                print("- imap log: \(string)")
//            } else {
//                print("- imap log error: \(type.rawValue)")
//            }
//        }
        
        // TODO: permanentlyDelete action
        /// delete https://github.com/MailCore/mailcore2/issues/1452
        /// Updating flags via IMAP https://github.com/MailCore/mailcore2/wiki/IMAP-Examples#updating-flags-via-imap
//        imapSession.expungeOperation(<#T##folder: String!##String!#>)
//        imapSession.storeFlagsOperation(withFolder: <#T##String!#>, uids: <#T##MCOIndexSet!#>, kind: <#T##MCOIMAPStoreFlagsRequestKind#>, flags: <#T##MCOMessageFlag#>)
        
        // TODO: trash action
        // TODO: find trash folder in list
        
        // TODO: Sending Attchaments using MailCore2 on ios 8 https://stackoverflow.com/a/26867310/5893286
        
        // TODO: sync login
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//
        imapSession.checkAccountOperation()?.start({ (error) in
            if let error = error {
                print("- imap login error:", error.localizedDescription)
            } else {
                print("success imapSession")
            }
        })
        
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
    
    /// similar to fetchFolderStatus. even in doc
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
    
    func fetchEmails(for folder: String, handler: @escaping (Result<[MCOIMAPMessage], Error>) -> Void) {
        
        /// range` from 1` = from the end of the email
        /// (0, 0) nil
        /// (0, 1) there is no callback
        /// (1, 0) = one last mail
        /// (1, 1) = two last mails
        /// so `MCORangeMake(FROM_UID, MAILS_COUNT - 1)` where FROM_UID=1 - last mail
        //let uids = MCOIndexSet(range: MCORangeMake(1, UInt64.max))
//        let uids = MCOIndexSet(range: MCORangeMake(2, 0))
        
        
        let total: UInt64 = 2
        let want: UInt64 = 2 - 1
//        let uids = MCOIndexSet(range: MCORangeMake(total - want, want))
//        let uids = MCOIndexSet(range: MCORangeMake(1, 10))
        let uids = MCOIndexSet(range: MCORangeMake(1, UInt64.max))
        
        let kind: MCOIMAPMessagesRequestKind = [.flags]//[.headers, .flags, .extraHeaders, .internalDate, .structure]
        //android 25
        
        /// depricated `let fetchOperation: MCOIMAPFetchMessagesOperation = imapSession.fetchMessagesByUIDOperation(withFolder: folder, requestKind: kind, uids: uids)`
        let fetchOperation: MCOIMAPFetchMessagesOperation = imapSession.fetchMessagesByNumberOperation(withFolder: folder, requestKind: kind, numbers: uids)
        
        fetchOperation.start { error, result, vanished in
            if let error = error {
                handler(.failure(error))
            } else if let result = result as? [MCOIMAPMessage] {
                if let vanished = vanished {
                    print(vanished)
                    assertionFailure()
                }
//                print(result)
                handler(.success(result))
            } else {
                assertionFailure()
                // TODO: unknown error
                handler(.failure(NSError()))
            }
        }
        
    }
    
    func fetchEmails(for folder: String, from: UInt32, to: UInt32, handler: @escaping (Result<[MCOIMAPMessage], Error>) -> Void) {
        guard from < to else {
            assertionFailure()
            handler(.success([]))
            return
        }
        
        let uids = MCOIndexSet(range: MCORangeMake(UInt64(from), UInt64(to - from) - 1))
        let kind: MCOIMAPMessagesRequestKind = [.headers, .flags, .extraHeaders, .internalDate, .structure]
        
        let fetchOperation: MCOIMAPFetchMessagesOperation = imapSession.fetchMessagesOperation(withFolder: folder, requestKind: kind, uids: uids)
        //let fetchOperation: MCOIMAPFetchMessagesOperation = imapSession.fetchMessagesByUIDOperation(withFolder: folder, requestKind: kind, uids: uids)
        fetchOperation.start { error, result, vanished in
            if let error = error {
                handler(.failure(error))
            } else if let result = result as? [MCOIMAPMessage] {
                if let vanished = vanished {
                    print(vanished)
                    assertionFailure()
                }
//                print(result)
                handler(.success(result))
            } else {
                assertionFailure()
                // TODO: unknown error
                handler(.failure(NSError()))
            }
        }
        
    }
    
    
    
    func syncMessagesByUIDWithFolder(folder: String, modSeq: UInt64, handler: @escaping (Result<[MCOIMAPMessage], Error>) -> Void) {
        //let uids = MCOIndexSet(range: MCORangeMake(1, UInt64.max))
        
        let total: UInt64 = 1
        let want: UInt64 = 1 - 1
        // TODO: convert my array of UIDS to an MCOIndexSet -> create a new MCOIndexSet and use -addIndex: to add each uid
//        let uids = MCOIndexSet(range: MCORangeMake(total - want, want))
//        let uids = MCOIndexSet(range: MCORangeMake(1, 10))
        let uids = MCOIndexSet(range: MCORangeMake(1, UInt64.max))
        
        //let kind: MCOIMAPMessagesRequestKind = [.headers, .flags, .extraHeaders, .internalDate, .structure, .fullHeaders, .size, .headerSubject] //.gmailLabels, .gmailMessageID, .gmailThreadID
        let kind: MCOIMAPMessagesRequestKind = [.headers, .flags]
        
        /**
         
         sync logic:
         
         check remote and local uid_validity
         if local_uid_validity != remote_uid_validity {
            fetchAll
            local_uid_validity = remote_uid_validity
         } else {
            fetch from latest_local_mail_uid to uid_next
         }
         
         */
        
        /**
         search https://github.com/MailCore/mailcore2/issues?q=is%3Aissue+QRESYNC
         
         https://github.com/MailCore/mailcore2/issues/1746
         So how do people usually sync the new emails ?
         You need to use UIDVALIDITY on folder to make sure that the UIDs were the same.
         If UIDVALIDITY is the same, you can assume that UIDs are the same. Then, get the latests UIDs.

         Then, as @haithngn mentioned, UIDs could be removed by another email client. In this case, you need to get the list of messages anyway to update the list of messages that disappeared.

         QRESYNC, only implemented on a small amount of servers would solve proper syncing.

         */
        
        // TODO: optimization: combinaison of CONDSTORE + fetching only the list of uids should work https://github.com/MailCore/mailcore2/issues/752
        
        // modSeq: 10800 for yaani.
        ///  https://github.com/MailCore/mailcore2/issues?q=is%3Aissue+syncMessagesWithFolder
        /// modSeq if equl will not come
        /// uids to cut vanishedMessages
        /// modSeq to cut messages
        /// don't use `modSeq: 0` it is wrong working for yaani (modSeqValue = 0 for all messages and vanishedMessages will not come), so min `modSeq: 1`
        let syncOperation: MCOIMAPFetchMessagesOperation = imapSession.syncMessages(withFolder: folder, requestKind: kind, uids: uids, modSeq: modSeq)
        
        syncOperation.start { (error, messages, vanishedMessages) in
            
            if let error = error {
                handler(.failure(error))
            } else {
                /// @warn *Important*: This is only for servers that support Conditional Store. See [RFC4551](http://tools.ietf.org/html/rfc4551)
                if let messages = messages as? [MCOIMAPMessage] {
                    //print("- messages \(messages)")
//                    print("- modSeqValue", messages.map{ $0.modSeqValue})
                    print()
                    handler(.success(messages))
                }
                
                // modSeq / CONDSTORE or Conditional Store / QRESYNC
                // You can get modSeqValues in messages you fetch when fetching the list of messages. MCOIMAPMessage has a modSeqValue property.
                // another trick https://stackoverflow.com/q/26262531/5893286
                // https://github.com/MailCore/mailcore2/issues/483
                // search https://github.com/MailCore/mailcore2/issues?q=is%3Aissue+syncMessagesWithFolder
                
                // https://github.com/MailCore/mailcore2/issues/1671
                // If QRESYNC is not available (vanishedMessages), the best way is to list all the UID of a folder and remove locally the one that are not available remotely any more.
                // One trick to speed it up is to get UID only of the last x messages frequently (every couple of minutes or one IDLE notifications) and then do a full list of UIDs infrequently.
                /// vanishedMessages will be set only for servers that support QRESYNC. See [RFC5162](http://tools.ietf.org/html/rfc5162)
                if let vanishedMessages = vanishedMessages {
                    print("- vanishedMessages \(vanishedMessages)")
                }
                
                
                
//                handler(.success(()))
            }
        }
    }
    
    
    func send() {
        
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: nil, mailbox: "zdaecq@gmail.com")!]
        /// will not work for gmail if mailbox != username
//        builder.header.from = MCOAddress(displayName: nil, mailbox: "witchkingforever@yandex.ru")
        builder.header.from = MCOAddress(displayName: nil, mailbox: username)
//        zzdaecq@gmail.com
        builder.header.subject = "Test message"
        builder.htmlBody = "Yo, this is a test message!"
        //builder.addAttachment(MCOAttachment(text: "MCOAttachment"))

        let rfc822Data = builder.data()
        
        /// will try to auth if wasn't
        let sendOperation: MCOSMTPSendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation.start { [weak self] error in
            if let error = error {
                
                let nsError = error as NSError
                if nsError.domain == MCOErrorDomain, nsError.code == 30 {
                    print("Error sending email: Sender address rejected: not owned by auth user")
                } else {
                    print("Error sending email: \(error)")
                }
            } else {
                print("Successfully sent email!")
                
                /// issue https://github.com/MailCore/mailcore2/issues/366
                /// need for `yandex`. don't need for `gmail`
                /// save in Sent folder. don't use "SENT"
                self?.imapSession.appendMessageOperation(withFolder: "Sent", messageData: rfc822Data, flags: [.seen])?.start { error, createdUID in
                // TODO: GMAIL
//                self?.imapSession.appendMessageOperation(withFolder: "[Gmail]/&BB4EQgQ,BEAEMAQyBDsENQQ9BD0ESwQ1-", messageData: rfc822Data, flags: [.seen])?.start { error, createdUID in
                    if let error = error {
                        print("Error saving email: \(error)")
                    } else {
                        print("Successfully saved email in SENT folder! id: \(createdUID)")
                    }
                }
                
            }
            
        }
        
        
        
        
    }
    
    func searchLocalsToDelete(handler: @escaping () -> Void) {
        /// An error occurred while fetching messages in the requested folder
        /// max `0..<2609` for "life" server (count 2609)
        let uids: [UInt32]
        if DataSource.shared.emails.count > 2609 {
            uids = DataSource.shared.emails[0..<2609].compactMap { $0.uid }
        } else {
            uids = DataSource.shared.emails.compactMap { $0.uid }
        }
        
        
        let requestUidsSet = MCOIndexSet(uids)
        
//        let searchExpression = MCOIMAPSearchExpression.searchHeader("Message-ID", value: "SOME_ID")
        let searchExpression = MCOIMAPSearchExpression.searchUIDs(requestUidsSet)
        imapSession.searchExpressionOperation(withFolder: "INBOX", expression: searchExpression)?.start { error, indexSet in
            if let error = error {
//                handler(.failure(error))
                print(error)
                handler()
            } else if let responseIndexSet = indexSet {
                let isDeletedSomething = requestUidsSet != responseIndexSet
                print("is deleted something?", isDeletedSomething)
                
                guard isDeletedSomething else {
//                    print("--------")
                    handler()
                    return
                }
                
                print("- request: \(requestUidsSet)")
                print("- response: \(responseIndexSet)")
                requestUidsSet.remove(responseIndexSet)
                print("- deleted: \(requestUidsSet)")
                
                var deleteCount = 0
                requestUidsSet.enumerate { uid in
                    deleteCount += 1
                    
                    if let index = DataSource.shared.emails.firstIndex(where: { $0.uid == uid}) {
                        DataSource.shared.emails.remove(at: index)
                    } else {
                        deleteCount -= 1
                        assertionFailure()
                    }
                    
                }
                print("- deleteCount: \(deleteCount)")
//                print("--------")
                
                handler()
                
                /// UnsafeBufferPointer to Array https://gist.github.com/kirsteins/6d6e96380db677169831
//                let ranges = Array(UnsafeBufferPointer(start: uidsSet.allRanges(), count: Int(uidsSet.rangesCount())))
//                    .map { NSRange(location: Int($0.location), length: Int($0.length)) }
//                    .compactMap { Range<Int>.init($0) }
//                assert(ranges.count == uidsSet.rangesCount())
//
//                let emailCountWas = DataSource.shared.emails.count
//                print("- email count: \(DataSource.shared.emails.count)")
//                // Fatal error: Array replace: subrange extends past the end
//                ranges.forEach { DataSource.shared.emails.removeSubrange($0) }
//                print("- email count: \(DataSource.shared.emails.count)")
//                assert(emailCountWas - DataSource.shared.emails.count == deleteCount)
                
                print()
//                handler(.success(result))
            } else {
                assertionFailure()
                // TODO: unknown error
//                handler(.failure(NSError()))
                handler()
            }
        }
        
        
//        imapSession.searchOperation(withFolder: <#T##String!#>, kind: <#T##MCOIMAPSearchKind#>, search: <#T##String!#>)
        
        
    }
    
    // TODO: !!!
    func searchLocalsToDelete(folder: String, uids: [UInt32],  handler: @escaping () -> Void) {
        let requestUidsSet = MCOIndexSet(uids)
        let searchExpression = MCOIMAPSearchExpression.searchUIDs(requestUidsSet)
        imapSession.searchExpressionOperation(withFolder: folder, expression: searchExpression)?.start { error, indexSet in
            if let error = error {
//                handler(.failure(error))
                print(error)
                handler()
            } else if let responseIndexSet = indexSet {
                let isDeletedSomething = requestUidsSet != responseIndexSet
                print("is deleted something?", isDeletedSomething)
                
                guard isDeletedSomething else {
//                    print("--------")
                    handler()
                    return
                }
                
                print("- request: \(requestUidsSet)")
                print("- response: \(responseIndexSet)")
                requestUidsSet.remove(responseIndexSet)
                print("- deleted: \(requestUidsSet)")
                
                var deleteCount = 0
                requestUidsSet.enumerate { uid in
                    deleteCount += 1
                    
                    if let index = DataSource.shared.emails.firstIndex(where: { $0.uid == uid}) {
                        DataSource.shared.emails.remove(at: index)
                    } else {
                        deleteCount -= 1
                        assertionFailure()
                    }
                    
                }
                print("- deleteCount: \(deleteCount)")
//                print("--------")
                
                handler()
                print()
//                handler(.success(result))
            } else {
                assertionFailure()
                // TODO: unknown error
//                handler(.failure(NSError()))
                handler()
            }
        }
    }
    
    
    
    func updateLocalEmails(folder: String, handler: @escaping () -> Void) {
        // TODO: batch update(fetch by pages)
        //let uids = DataSource.shared.emails.compactMap { $0.uid }
        let uids: [UInt32]
        // not 2609 like for search delete
        // TODO: check for different kind. 2608 for life server and kine = .flags
        let limit = 2608
        if DataSource.shared.emails.count > limit {
            uids = DataSource.shared.emails[0..<limit].compactMap { $0.uid }
        } else {
            uids = DataSource.shared.emails.compactMap { $0.uid }
        }
        let requestUidsSet = MCOIndexSet(uids)
        
        /// only flags can be changes so we fetch only them
        let kind: MCOIMAPMessagesRequestKind = [.flags]
        
        let fetchOperation: MCOIMAPFetchMessagesOperation = imapSession.fetchMessagesOperation(withFolder: folder, requestKind: kind, uids: requestUidsSet)
        fetchOperation.start { error, result, vanished in
            if let error = error {
//                handler(.failure(error))
                print(error)
                handler()
            } else if let result = result as? [MCOIMAPMessage] {
                if let vanished = vanished {
                    print(vanished)
                    assertionFailure()
                }
                
                var updatedCount = 0
                for email in result {
                    // TODO: update flags if need
                    let localEmail = DataSource.shared.emails.first(where: { $0.uid == email.uid })!
                    if localEmail.flags != email.flags {
                        localEmail.flags = email.flags
                        //print("updated: \(localEmail.uid) - \(localEmail.header.receivedDate!), \(localEmail.header.subject!)")
                        print("updated: \(localEmail.uid) - \(localEmail.header.receivedDate!))")
                        updatedCount += 1
                    }
                }
                print("- updated count: \(updatedCount)")
                
                handler()
                
//                print(result)
//                handler(.success(result))
            } else {
                assertionFailure()
                handler()
                // TODO: unknown error
//                handler(.failure(NSError()))
            }
        }
        
        
//        imapSession.searchOperation(withFolder: <#T##String!#>, kind: <#T##MCOIMAPSearchKind#>, search: <#T##String!#>)
        
        
    }
    
    
    /**
     
     если нет новых сообщений, не удалялись письма, нет изменений в папке, то не надо проверять все локальные письма на флаги
     
     если modeSeq не поддерживается, то отправляем все локалки на получение флагов
     если modeSeq поддерживается, то пользуемся sync
     
     */
    
    func sync() {
        

        
        MailCoreManager.shared.fetchFolderStatus(folder: "INBOX") { result in
            switch result {
            case .success(let status):
                print("- folder status: \(status)")
                
                // TODO: try find HighestModSeqChanged | a HIGHESTMODSEQ resp-code is sent by the server (signifying that the value has changed)
                // TODO: check https://github.com/jstedfast/MailKit/issues/805
                // TODO: check https://stackoverflow.com/questions/54232790/mailkit-imap-fetch-only-new-not-downloaded-messages
                if DataSource.shared.uidValidity == status.uidValidity {
                    /// fetch new + check local
                             
                    // TODO: chunk
                    /// check and delete old locals
                    MailCoreManager.shared.searchLocalsToDelete() {
                        
                        /// highestModSeqValue
                        /// - yandex
                        /// + gmail
                        /// + yaani
                        if DataSource.shared.highestModSeqValue == 0 {
                            
                            /// do manual sync
                            print("- highestModSeqValue is not supported")

                            // TODO: chunk
                            MailCoreManager.shared.updateLocalEmails(folder: "INBOX") {
                                print("- updated local emails")
                                
                                
                                let isThereNewMails = (DataSource.shared.uidNext != status.uidNext)
                                
                                if isThereNewMails {
                                    
                                    // TODO: chunk
                                    MailCoreManager.shared.fetchEmails(for: "INBOX", from: DataSource.shared.uidNext, to: status.uidNext) { result in
                                        switch result {
                                        case .success(let emails):
                                            print("++++++++ new emails: \(emails.count)")
            
                                            for email in emails {
                                                print("\(email.uid) - \(email.header.receivedDate!), \(email.header.subject!)")
                                            }
                                            print("--------")
            
                                            DataSource.shared.emails.append(contentsOf: emails)
                                            DataSource.shared.uidNext = status.uidNext
                                            assert(DataSource.shared.emails.count == status.messageCount)
            
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                            print()
                                        }
                                    }
            
            
                                } else {
                                    print("- there is no new emails")
                                    print("--------")
                                    assert(DataSource.shared.emails.count == status.messageCount)
                                }
                                
                            }
                            
                            
                            
                            
                        } else {
                            
                            /// or `!=`
                            if DataSource.shared.highestModSeqValue < status.highestModSeqValue {
                                
                                print("- there are changes in the folder")
                                
                                // TODO: can be a problem with return emails count (too many)
                                // TODO: chunk (try)
                                MailCoreManager.shared.syncMessagesByUIDWithFolder(folder: "INBOX", modSeq: DataSource.shared.highestModSeqValue) { result in
                                    switch result {
                                    case .success(let emails):
                                        print("++++++++ emails: \(emails.count)")
                                        
                                        for email in emails {
                                            
                                            if email.uid >= DataSource.shared.uidNext {
                                                print("new: \(email.uid) - \(email.header.receivedDate!), \(email.header.subject!)")
                                                DataSource.shared.emails.append(email)
                                            } else {
                                                print("updated: \(email.uid) - \(email.header.receivedDate!), \(email.header.subject!)")
                                                /// `!` bcz we sure that we have it
                                                DataSource.shared.emails.first(where: { $0.uid == email.uid })!.flags = email.flags
                                            }
                                            
                                        }
                                        print("--------")
                                        
                                        DataSource.shared.uidNext = status.uidNext
                                        DataSource.shared.highestModSeqValue = status.highestModSeqValue
                                        
                                        assert(DataSource.shared.emails.count == status.messageCount)
                                        
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                        print()
                                    }
                                }
                                
                                
                            } else {
                                assert(DataSource.shared.emails.count == status.messageCount)
                                print("- there are NO changes in the folder")
                                print("--------")
                            }
                        }
                        
                        
                        
                    }
                    
                        
                    
                } else {
                    /// fetch all
                    
                    // TODO: chunk
                    MailCoreManager.shared.fetchEmails(for: "INBOX") { result in
                        switch result {
                        case .success(let emails):
                            print("++++++++ all:")
                            
                            
                            for email in emails {
                                //print("\(email.uid) - \(email.header.receivedDate!), \(email.header.subject!)")
                                print("\(email.uid) - \(email.header.receivedDate!)")
                            }
                            
                            print("--------")
                            
                            DataSource.shared.uidValidity = status.uidValidity
                            DataSource.shared.uidNext = status.uidNext
                            DataSource.shared.highestModSeqValue = status.highestModSeqValue
                            
                            DataSource.shared.emails = emails
                            
                            assert(DataSource.shared.emails.count == status.messageCount)
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                            print()
                            // TODO: retry
                        }
                    }
                    
                    
                    
                    
                }
                
                
                
                
            case .failure(let error):
                print(error.localizedDescription)
                print()
            }
        }

        
        
    }
    
    
    
    func folders() {
        
        fetchAllFolder { result in
            switch result {
            case .success(let folders):
                /// INBOX in yandex `folders[1].path`
//                print(folders)
                
                // TODO: check MCOIMAPNamespace().components(fromPath: PATH) https://github.com/MailCore/mailcore2/issues/1554
                /// needs for russian folder names (gmail, yandex)
                func IMAPtoUTF8(str: String) -> String? {
                    /// https://github.com/MailCore/mailcore2/issues/1554
                    let cfEncoding = CFStringEncoding(CFStringEncodings.UTF7_IMAP.rawValue)
                    let nsEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding)
                    let encoding = String.Encoding(rawValue: nsEncoding)

                    let cString = str.cString(using: String.defaultCStringEncoding)!
                    return String(cString: cString, encoding: encoding)
                }
                
                for folder in folders {
                    
                    //                    if folder.flags == .folderTypeMask {
                    /// Imap server support folder flags
                    
                    
                    /// IMAP has 3 main folders - All Mail, Trash and Spam https://github.com/MailCore/mailcore2/issues/1484#issuecomment-235821386
                    
                    
                    // TODO: check more
                    // for yandex:
                    // not working: "sent", "SENT" `The requested folder does not exist.  Folder selection failed`
                    // working: "Sent", "INBOX", "inbox", "Inbox"
                    //
                    // TODO: `result.first!.flags == .sentMail` As i saw some servers doesnt support this flag check. But if it support we will use it otherwise current checking will work
                    
                    
                    
//                    let flags = folder.flags
//                    let q = flags ~= .inbox
                    
//                    MCOIMAPFolderFlag
                    

                    
//                    if flags.contains(.inbox) {
//                        print("inbox:", terminator: "")
//                    } else if flags.contains(.drafts) {
//                        print("drafts:", terminator: "")
//                    } else {
//                        print("other:", terminator: "")
//                    }
//                      //vs
//                    switch flags {
//                    case _ where flags.contains(.inbox):
//                        print("inbox:", terminator: "")
//                    case _ where flags.contains(.drafts):
//                        print("drafts:", terminator: "")
//                    default:
//                        print("other:", terminator: "")
//                    }
                    
                    
                    
                    /// used global func
                    //func ~= (pattern: MCOIMAPFolderFlag, value: MCOIMAPFolderFlag) -> Bool {
                    //    return value.contains(pattern)
                    //}
                    switch folder.flags {
                    case .inbox:
                        print("inbox:", terminator: "")
                    case .drafts:
                        print("drafts:", terminator: "")
                    case .sentMail:
                        print("sent:", terminator: "")
                    case .trash:
                        print("trash:", terminator: "")
                    case .spam: /// same as .junk
                        print("spam:", terminator: "")
                    case .important:
                        /// gmail has
                        print("important:", terminator: "")
//                    case []:
//                        //gmail "INBOX"
//                        print("none:", terminator: "")
                    case .noSelect:
                        //gmail "[Gmail]"
                        print("skip:", terminator: "")
                    case .allMail:
                        /// gmail spam not included
                        print("allMail:", terminator: "")
                    case .starred:
                        /// gmail has, yandex not
                        print("starred:", terminator: "")
                    case .archive:
                        /// gmail has no it. Google's method of "Archiving" - simply removing the "Inbox Label". use allMail for it
                        /// gmail logic https://gmail-miscellany.blogspot.com/2012/10/how-gmail-stores-your-mail.html
                        print("archive:", terminator: "")
                    case .unmarked, []:
                        /// user custom folder
                        /// yandex, yaani has. gmail has no it
                        /// gmail INBOX here
                        /// yandex Outbox here
                        print("custom:", terminator: "")
                    default:
                        
                        // TODO: imapFolder.path
//                        switch imapFolder.path.lowercased() {
//                        case "inbox":

//                        case "drafts":

//                        case "sent":

//                        case "trash":

//                        case "spam", "junk":

//                        case "outbox":
//                            /// I'm not sure for this. bcz user cant open mail detail from oubox folder. it acts our local folder.

//                        default:
//                            folder.id = imapFolder.path
//                        }
                        
                        
                        
                        print("other:", terminator: "")
                    }
                    
                    
                    //                    }
                    
                    print(IMAPtoUTF8(str: folder.path)!, folder.path!)
                    
//                    print()
                    
                }
                
                // TODO: check type https://stackoverflow.com/a/32713563/5893286


                /// utf7 "+g0l6P3ux-"
                //print(IMAPtoUTF8(str: "+g0l6P3ux-")!)
                //print(folders.compactMap{ IMAPtoUTF8(str: $0.path)})


                print()
            case .failure(let error):
                print(error.localizedDescription)
                print()
            }
        }
        
    }
    
    
}



/** test
 let uids = ["1"]
 let indexSet = MCOIndexSet()
 uids.forEach { (uid) in
     if let uidUInt64 = UInt64(uid) {
         indexSet.add(uidUInt64)
     }
 }
 let q = MCOIndexSet(uids)
 print(q == indexSet)
 print()
 */
// TODO: use
extension MCOIndexSet {
    
    convenience init(_ uids: [String]) {
        self.init()
        
        uids.compactMap { UInt64($0) }
            .forEach { add($0) }
    }
    
    convenience init(_ uids: [UInt32]) {
        self.init()
        
        uids.compactMap { UInt64($0) }
            .forEach { add($0) }
    }
    
}

extension Collection {
    
    /** test
     //        if let f = array.first, array.dropFirst().first(where: { $0.title != f.title }) == nil {
     //
     //        }
             
             struct QQQ {
                 let title: String
             }
             
             let array = [QQQ(title: "1"), QQQ(title: "1")]
             
             let isSameTitle = array.isPropertiesEquals(by: \.title)
             print("isSameTitle: \(isSameTitle)")
             assert(array.isPropertiesEquals(by: \.title))
     */
    // TODO: use
    func isPropertiesEquals<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Bool {
        if let firstItem = first, dropFirst().first(where: { $0[keyPath: keyPath] != firstItem[keyPath: keyPath] }) != nil {
            return false
        } else {
            return true
        }
    }
    
    /// `?` needs for optinal properties
    func isPropertiesEquals<T: Comparable>(by keyPath: KeyPath<Element, T?>) -> Bool {
        if let firstItem = first, dropFirst().first(where: { $0[keyPath: keyPath] != firstItem[keyPath: keyPath] }) != nil {
            return false
        } else {
            return true
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
