import UIKit
import MessageKit
import InputBarAccessoryView

import MessengerKit

struct User2: MSGUser {
    var displayName: String
    var avatar: UIImage?
    var avatarUrl: URL?
    var isSender: Bool
}


class MSGChatController: MSGMessengerViewController {
    
    let steve = User2(displayName: "Steve", avatar: nil, avatarUrl: nil, isSender: true)
    let tim = User2(displayName: "Tim", avatar: nil, avatarUrl: nil, isSender: false)
    
    lazy var messages: [[MSGMessage]] = {
        return [
            [
                MSGMessage(id: 1, body: .emoji("🐙💦🔫"), user: tim, sentAt: Date()),
            ],
            [
                MSGMessage(id: 2, body: .text("Yeah sure, gimme 5"), user: steve, sentAt: Date()),
                MSGMessage(id: 3, body: .text("Okay ready when you are"), user: steve, sentAt: Date())
            ],
            [
                MSGMessage(id: 4, body: .text("Awesome 😁"), user: tim, sentAt: Date()),
            ],
            [
                MSGMessage(id: 5, body: .text("Ugh, gotta sit through these two…"), user: steve, sentAt: Date()),
                MSGMessage(id: 6, body: .image(#imageLiteral(resourceName: "Splatoon")), user: steve, sentAt: Date()),
            ],
            [
                MSGMessage(id: 7, body: .text("Every. Single. Time."), user: tim, sentAt: Date()),
            ],
            [
                MSGMessage(id: 8, body: .emoji("🙄😭"), user: steve, sentAt: Date()),
                MSGMessage(id: 9, body: .imageFromUrl(URL(string: "https://placeimg.com/640/480/any")!), user: steve, sentAt: Date()
                )
            ]
        ]
    }()
    
    override var style: MSGMessengerStyle {
        var style = MessengerKit.Styles.iMessage
        style.headerHeight = 0
//        style.inputPlaceholder = "Message"
//        style.alwaysDisplayTails = true
//        style.outgoingBubbleColor = .magenta
//        style.outgoingTextColor = .black
//        style.incomingBubbleColor = .green
//        style.incomingTextColor = .yellow
//        style.backgroundColor = .orange
//        style.inputViewBackgroundColor = .purple
        return style
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.scrollToBottom(animated: false)
    }

    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        let message = MSGMessage(id: 10, body: .text(inputView.message), user: steve, sentAt: Date())
        insert(message)
    }
    
    override func insert(_ message: MSGMessage) {
        
        collectionView.performBatchUpdates({
            if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                self.messages[self.messages.count - 1].append(message)
                
                let sectionIndex = self.messages.count - 1
                let itemIndex = self.messages[sectionIndex].count - 1
                self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
                
            } else {
                self.messages.append([message])
                let sectionIndex = self.messages.count - 1
                self.collectionView.insertSections([sectionIndex])
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: true)
            self.collectionView.layoutTypingLabelIfNeeded()
        })
        
    }
    
    override func insert(_ messages: [MSGMessage], callback: (() -> Void)? = nil) {
        
        collectionView.performBatchUpdates({
            for message in messages {
                if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                    self.messages[self.messages.count - 1].append(message)
                    
                    let sectionIndex = self.messages.count - 1
                    let itemIndex = self.messages[sectionIndex].count - 1
                    self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
                    
                } else {
                    self.messages.append([message])
                    let sectionIndex = self.messages.count - 1
                    self.collectionView.insertSections([sectionIndex])
                }
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: false)
            self.collectionView.layoutTypingLabelIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                callback?()
            }
        })
        
    }
    
}

// MARK: - MSGDataSource

extension MSGChatController: MSGDataSource {
    
    func numberOfSections() -> Int {
        return messages.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return messages[section].count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        return messages[indexPath.section][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return "Just now"
    }
    
    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }

}

extension MSGChatController: MSGDelegate {
    func tapReceived(for message: MSGMessage) {
        print(message)
    }
}



// TODO: base on ChatViewController
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}



/// A base class
/// source https://github.com/MessageKit/MessageKit
/// basic example https://github.com/MessageKit/MessageKit/blob/master/Example/Sources/View%20Controllers/ChatViewController.swift
/// there is no start from bottom https://github.com/MessageKit/MessageKit/issues?q=is%3Aissue+CGAffineTransform
class ChatViewController: MessagesViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    //open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    var messageList: [MockMessage] = []
    
    var isLoadingList = false
    var isAllRecordsLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageCollectionView()
        configureMessageInputBar()
        loadFirstMessages()
        title = "MessageKit"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: start socket connection
//        MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu])
//            .onNewMessage { [weak self] message in
//                self?.insertMessage(message)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // TODO: stop socket connection
    }
    
    func loadFirstMessages() {
        DispatchQueue.global(qos: .userInitiated).async {
            let messages = DataProvider.shared.messages
            
            DispatchQueue.main.async {
                self.messageList = messages
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
                
                /// not safe. read doc
                //self.messagesCollectionView.scrollToBottom()
            }
        }
    }
    
    private func loadMoreMessages() {
        
        isLoadingList = true
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            let messages = DataProvider.shared.messages
            
            /// like "messages < limit" from server
            if self.messageList.count > 100 {
                self.isAllRecordsLoaded = true
                return
            }
            
            DispatchQueue.main.async {
                self.messageList.insert(contentsOf: messages, at: 0)
                self.messagesCollectionView.reloadDataAndKeepOffset()
                self.isLoadingList = false
            }
        }
    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            //layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            //layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            
            ///or
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageIncomingAvatarSize(.zero)
        }
    }
    
    func configureMessageInputBar() {
        
        let buttonWidth: CGFloat = 36
        messageInputBar.setRightStackViewWidthConstant(to: buttonWidth, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: buttonWidth, height: buttonWidth), animated: false)
        
        /// or 1
        //messageInputBar.sendButton.image = UIImage(systemName: "arrow.up")
        //messageInputBar.sendButton.title = nil
        
        /// or 2
        messageInputBar.sendButton.title = "↑"
        messageInputBar.sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        messageInputBar.sendButton.setTitleColor(.primaryColor, for: .normal)
        messageInputBar.sendButton.setTitleColor(UIColor.primaryColor.withAlphaComponent(0.3),
                                                 for: .highlighted)
        
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.middleContentViewPadding.right = -38
        
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .primaryColor
    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        guard !messageList.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    /// https://github.com/MessageKit/MessageKit/issues/441
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        if indexPath.section < 4 {   // Are we within 3 rows from the top?
            if !isLoadingList && !isAllRecordsLoaded {
                loadMoreMessages()
            }
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return DataProvider.shared.meUser
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
}

/// The MessagesLayoutDelegate and MessagesDisplayDelegate don't require you to implement any methods as they have default implementations for everything. You just need to make your MessagesViewController subclass conform to these two protocols and set them in the MessagesCollectionView object
extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(tail, .curved)
//    }
    
    /// or:
    ///layout?.setMessageOutgoingAvatarSize(.zero)
    ///layout?.setMessageIncomingAvatarSize(.zero)
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView.isHidden = true
//    }
    
//    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? .white : .darkText
//    }
    
//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? .primaryColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
//    }
    
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//
//        let sender = message.sender
//
//        let firstName = sender.displayName.components(separatedBy: " ").first
//        let lastName = sender.displayName.components(separatedBy: " ").first
//        let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
//
//        let avatar = Avatar(image: nil, initials: initials)
//        avatarView.set(avatar: avatar)
//    }
}

// MARK: - MessageInputBarDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()

        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = DataProvider.shared.meUser
            if let str = component as? String {
                let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
//            else if let img = component as? UIImage {
//                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
//                insertMessage(message)
//            }
        }
    }
}

// MARK: - MessageCellDelegate
extension ChatViewController: MessageCellDelegate {
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        print("did tap on: \(message.kind)")
    }
    
}
