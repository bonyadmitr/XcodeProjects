
import Chatto
import ChattoAdditions

/// source https://github.com/badoo/Chatto
class ChattoController: BaseChatViewController {
    var shouldUseAlternativePresenter: Bool = false

    var messageSender: DemoChatMessageSender!
    let messagesSelector = BaseMessagesSelector()

    var dataSource: DemoChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.messageSender = self.dataSource.messageSender
        }
    }

//    lazy private var baseMessageHandler: BaseMessageHandler = {
//        return BaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
                let messages = [
                    DemoChatMessageFactory.makeTextMessage(UUID().uuidString, text: "qweqwe", isIncoming: true),
                    DemoChatMessageFactory.makeTextMessage(UUID().uuidString, text: "qweqwe\nweqe", isIncoming: true),
                    DemoChatMessageFactory.makeTextMessage(UUID().uuidString, text: "qweqwe\nwer\n2312", isIncoming: true),
                ]
        
                self.dataSource = DemoChatDataSource(messages: messages, pageSize: 50)

        self.title = "Chat"
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
    }

    var chatInputPresenter: AnyObject!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        if self.shouldUseAlternativePresenter {
            let chatInputPresenter = ExpandableChatInputBarPresenter(
                inputPositionController: self,
                chatInputBar: chatInputView,
                chatInputItems: self.createChatInputItems(),
                chatInputBarAppearance: appearance)
            self.chatInputPresenter = chatInputPresenter
            self.keyboardEventsHandler = chatInputPresenter
            self.scrollViewEventsHandler = chatInputPresenter
        } else {
            self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        }
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {

        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: self.createTextMessageViewModelBuilder(),
            interactionHandler: GenericMessageHandler()
        )
//        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
//
//        let photoMessagePresenter = PhotoMessagePresenterBuilder(
//            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
//            interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler)
//        )
//        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()
//
//        let compoundPresenterBuilder = CompoundMessagePresenterBuilder(
//            viewModelBuilder: DemoCompoundMessageViewModelBuilder(),
//            interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler),
//            accessibilityIdentifier: nil,
//            contentFactories: [
//                .init(DemoTextMessageContentFactory()),
//                .init(DemoImageMessageContentFactory()),
//                .init(DemoDateMessageContentFactory())
//            ],
//            compoundCellDimensions: .defaultDimensions,
//            baseCellStyle: BaseMessageCollectionViewCellAvatarStyle()
//        )

        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter]
        ]
    }

    func createTextMessageViewModelBuilder() -> DemoTextMessageViewModelBuilder {
        return DemoTextMessageViewModelBuilder()
    }

    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
//        items.append(self.createPhotoInputItem())
        if self.shouldUseAlternativePresenter {
            items.append(self.customInputItem())
        }
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }

//    private func createPhotoInputItem() -> PhotosChatInputItem {
//        let item = PhotosChatInputItem(presentingController: self)
//        item.photoInputHandler = { [weak self] image, _ in
//            self?.dataSource.addPhotoMessage(image)
//        }
//        return item
//    }

    private func customInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }
}

extension ChattoController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }

    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}


final class GenericMessageHandler<ViewModel: DemoMessageViewModelProtocol & MessageViewModelProtocol>: BaseMessageInteractionHandlerProtocol {

//    private let baseHandler: BaseMessageHandler

//    init(baseHandler: BaseMessageHandler) {
//        self.baseHandler = baseHandler
//    }

    func userDidTapOnFailIcon(viewModel: ViewModel, failIconView: UIView) {
//        self.baseHandler.userDidTapOnFailIcon(viewModel: viewModel)
    }

    func userDidTapOnAvatar(viewModel: ViewModel) {
//        self.baseHandler.userDidTapOnAvatar(viewModel: viewModel)
    }

    func userDidTapOnBubble(viewModel: ViewModel) {
//        self.baseHandler.userDidTapOnBubble(viewModel: viewModel)
    }

    func userDidBeginLongPressOnBubble(viewModel: ViewModel) {
//        self.baseHandler.userDidBeginLongPressOnBubble(viewModel: viewModel)
    }

    func userDidEndLongPressOnBubble(viewModel: ViewModel) {
//        self.baseHandler.userDidEndLongPressOnBubble(viewModel: viewModel)
    }

    func userDidSelectMessage(viewModel: ViewModel) {
//        self.baseHandler.userDidSelectMessage(viewModel: viewModel)
    }

    func userDidDeselectMessage(viewModel: ViewModel) {
//        self.baseHandler.userDidDeselectMessage(viewModel: viewModel)
    }
}
//
//class BaseMessageHandler {
//
//    private let messageSender: DemoChatMessageSender
//    private let messagesSelector: MessagesSelectorProtocol
//
//    init(messageSender: DemoChatMessageSender, messagesSelector: MessagesSelectorProtocol) {
//        self.messageSender = messageSender
//        self.messagesSelector = messagesSelector
//    }
//    func userDidTapOnFailIcon(viewModel: DemoMessageViewModelProtocol) {
//        print("userDidTapOnFailIcon")
//        self.messageSender.sendMessage(viewModel.messageModel)
//    }
//
//    func userDidTapOnAvatar(viewModel: MessageViewModelProtocol) {
//        print("userDidTapOnAvatar")
//    }
//
//    func userDidTapOnBubble(viewModel: DemoMessageViewModelProtocol) {
//        print("userDidTapOnBubble")
//    }
//
//    func userDidBeginLongPressOnBubble(viewModel: DemoMessageViewModelProtocol) {
//        print("userDidBeginLongPressOnBubble")
//    }
//
//    func userDidEndLongPressOnBubble(viewModel: DemoMessageViewModelProtocol) {
//        print("userDidEndLongPressOnBubble")
//    }
//
//    func userDidSelectMessage(viewModel: DemoMessageViewModelProtocol) {
//        print("userDidSelectMessage")
//        self.messagesSelector.selectMessage(viewModel.messageModel)
//    }
//
//    func userDidDeselectMessage(viewModel: DemoMessageViewModelProtocol) {
//        print("userDidDeselectMessage")
//        self.messagesSelector.deselectMessage(viewModel.messageModel)
//    }
//}


import ChattoAdditions

public class DemoTextMessageViewModel: TextMessageViewModel<DemoTextMessageModel>, DemoMessageViewModelProtocol {

    public override init(textMessage: DemoTextMessageModel, messageViewModel: MessageViewModelProtocol) {
        super.init(textMessage: textMessage, messageViewModel: messageViewModel)
    }

    public var messageModel: DemoMessageModelProtocol {
        return self.textMessage
    }
}

public protocol DemoMessageViewModelProtocol {
    var messageModel: DemoMessageModelProtocol { get }
}

open class TextMessageViewModel<TextMessageModelT: TextMessageModelProtocol>: TextMessageViewModelProtocol {
    open var text: String {
        return self.textMessage.text
    }
    public let textMessage: TextMessageModelT
    public let messageViewModel: MessageViewModelProtocol
    public let cellAccessibilityIdentifier = "chatto.message.text.cell"
    public let bubbleAccessibilityIdentifier = "chatto.message.text.bubble"

    public init(textMessage: TextMessageModelT, messageViewModel: MessageViewModelProtocol) {
        self.textMessage = textMessage
        self.messageViewModel = messageViewModel
    }

    open func willBeShown() {
        // Need to declare empty. Otherwise subclass code won't execute (as of Xcode 7.2)
    }

    open func wasHidden() {
        // Need to declare empty. Otherwise subclass code won't execute (as of Xcode 7.2)
    }
}

public class DemoTextMessageViewModelBuilder: ViewModelBuilderProtocol {

    typealias ObservableImageProvider = (DemoTextMessageModel) -> Observable<UIImage?>

    private static let defaultObservableImageProvider: ObservableImageProvider = { _ in Observable(UIImage(named: "userAvatar")) }

    private let imageProvider: ObservableImageProvider

    init(imageProvider: @escaping ObservableImageProvider = DemoTextMessageViewModelBuilder.defaultObservableImageProvider) {
        self.imageProvider = imageProvider
    }

    let messageViewModelBuilder = MessageViewModelDefaultBuilder()

    public func createViewModel(_ textMessage: DemoTextMessageModel) -> DemoTextMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(textMessage)
        let textMessageViewModel = DemoTextMessageViewModel(textMessage: textMessage, messageViewModel: messageViewModel)
        textMessageViewModel.avatarImage = self.imageProvider(textMessage)
        return textMessageViewModel
    }

    public func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is DemoTextMessageModel
    }
}

public protocol TextMessageModelProtocol: DecoratedMessageModelProtocol, ContentEquatableChatItemProtocol {
    var text: String { get }
}

open class TextMessageModel<MessageModelT: MessageModelProtocol>: TextMessageModelProtocol {
    public var messageModel: MessageModelProtocol {
        return self._messageModel
    }
    public let _messageModel: MessageModelT // Can't make messasgeModel: MessageModelT: https://gist.github.com/diegosanchezr/5a66c7af862e1117b556
    public let text: String
    public init(messageModel: MessageModelT, text: String) {
        self._messageModel = messageModel
        self.text = text
    }
    public func hasSameContent(as anotherItem: ChatItemProtocol) -> Bool {
        guard let anotherMessageModel = anotherItem as? TextMessageModel else { return false }
        return self.text == anotherMessageModel.text
    }
}

import Foundation
import ChattoAdditions

public class DemoTextMessageModel: TextMessageModel<MessageModel>, DemoMessageModelProtocol {
    public override init(messageModel: MessageModel, text: String) {
        super.init(messageModel: messageModel, text: text)
    }

    public var status: MessageStatus {
        get {
            return self._messageModel.status
        }
        set {
            self._messageModel.status = newValue
        }
    }
}

public protocol DemoMessageModelProtocol: MessageModelProtocol, ContentEquatableChatItemProtocol {
    var status: MessageStatus { get set }
}

class DemoChatDataSource: ChatDataSourceProtocol {
    var nextMessageId: Int = 0
    let preferredMaxWindowSize = 500

    var slidingWindow: SlidingDataSource<ChatItemProtocol>!
    init(count: Int, pageSize: Int) {
        self.slidingWindow = SlidingDataSource(count: count, pageSize: pageSize) { [weak self] () -> ChatItemProtocol in
            guard let sSelf = self else { return DemoChatMessageFactory.makeRandomMessage("") }
            defer { sSelf.nextMessageId += 1 }
            return DemoChatMessageFactory.makeRandomMessage("\(sSelf.nextMessageId)")
        }
    }

    init(messages: [ChatItemProtocol], pageSize: Int) {
        self.slidingWindow = SlidingDataSource(items: messages, pageSize: pageSize)
    }

    lazy var messageSender: DemoChatMessageSender = {
        let sender = DemoChatMessageSender()
        sender.onMessageChanged = { [weak self] (message) in
            guard let sSelf = self else { return }
            sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
        }
        return sender
    }()

    var hasMoreNext: Bool {
        return self.slidingWindow.hasMore()
    }

    var hasMorePrevious: Bool {
        return self.slidingWindow.hasPrevious()
    }

    var chatItems: [ChatItemProtocol] {
        return self.slidingWindow.itemsInWindow
    }

    weak var delegate: ChatDataSourceDelegateProtocol?

    func loadNext() {
        self.slidingWindow.loadNext()
        self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
        self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
    }

    func loadPrevious() {
        self.slidingWindow.loadPrevious()
        self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
        self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
    }

    func addTextMessage(_ text: String) {
        let uid = "\(self.nextMessageId)"
        self.nextMessageId += 1
        let message = DemoChatMessageFactory.makeTextMessage(uid, text: text, isIncoming: false)
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }

//    func addPhotoMessage(_ image: UIImage) {
//        let uid = "\(self.nextMessageId)"
//        self.nextMessageId += 1
//        let message = DemoChatMessageFactory.makePhotoMessage(uid, image: image, size: image.size, isIncoming: false)
//        self.messageSender.sendMessage(message)
//        self.slidingWindow.insertItem(message, position: .bottom)
//        self.delegate?.chatDataSourceDidUpdate(self)
//    }
//
//    func addRandomIncomingMessage() {
//        let message = DemoChatMessageFactory.makeRandomMessage("\(self.nextMessageId)", isIncoming: true)
//        self.nextMessageId += 1
//        self.slidingWindow.insertItem(message, position: .bottom)
//        self.delegate?.chatDataSourceDidUpdate(self)
//    }

    func removeRandomMessage() {
        self.slidingWindow.removeRandomItem()
        self.delegate?.chatDataSourceDidUpdate(self)
    }

    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion:(_ didAdjust: Bool) -> Void) {
        let didAdjust = self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
        completion(didAdjust)
    }

    func replaceMessage(withUID uid: String, withNewMessage newMessage: ChatItemProtocol) {
        let didUpdate = self.slidingWindow.replaceItem(withNewItem: newMessage) { $0.uid == uid }
        guard didUpdate else { return }
        self.delegate?.chatDataSourceDidUpdate(self)
    }
}


public enum InsertPosition {
    case top
    case bottom
}

public class SlidingDataSource<Element> {

    private var pageSize: Int
    private var windowOffset: Int
    private var windowCount: Int
    private var itemGenerator: (() -> Element)?
    private var items = [Element]()
    private var itemsOffset: Int
    public var itemsInWindow: [Element] {
        let offset = self.windowOffset - self.itemsOffset
        return Array(items[offset..<offset+self.windowCount])
    }

    public init(count: Int, pageSize: Int, itemGenerator: (() -> Element)?) {
        self.windowOffset = count
        self.itemsOffset = count
        self.windowCount = 0
        self.pageSize = pageSize
        self.itemGenerator = itemGenerator
        self.generateItems(min(pageSize, count), position: .top)
    }

    public convenience init(items: [Element], pageSize: Int) {
        var iterator = items.makeIterator()
        self.init(count: items.count, pageSize: pageSize) { iterator.next()! }
    }

    private func generateItems(_ count: Int, position: InsertPosition) {
        guard count > 0 else { return }
        guard let itemGenerator = self.itemGenerator else {
            fatalError("Can't create messages without a generator")
        }
        for _ in 0..<count {
            self.insertItem(itemGenerator(), position: .top)
        }
    }

    public func insertItem(_ item: Element, position: InsertPosition) {
        if position == .top {
            self.items.insert(item, at: 0)
            let shouldExpandWindow = self.itemsOffset == self.windowOffset
            self.itemsOffset -= 1
            if shouldExpandWindow {
                self.windowOffset -= 1
                self.windowCount += 1
            }
        } else {
            let shouldExpandWindow = self.itemsOffset + self.items.count == self.windowOffset + self.windowCount
            if shouldExpandWindow {
                self.windowCount += 1
            }
            self.items.append(item)
        }
    }

    public func removeRandomItem() {
        guard let randomIndex = self.items.indices.randomElement() else { return }
        let shouldShrinkWindow = self.itemsOffset + self.items.count == self.windowOffset + self.windowCount
        if shouldShrinkWindow {
            self.windowCount -= 1
        }
        self.items.remove(at: randomIndex)
    }

    public func hasPrevious() -> Bool {
        return self.windowOffset > 0
    }

    public func hasMore() -> Bool {
        return self.windowOffset + self.windowCount < self.itemsOffset + self.items.count
    }

    public func loadPrevious() {
        let previousWindowOffset = self.windowOffset
        let previousWindowCount = self.windowCount
        let nextWindowOffset = max(0, self.windowOffset - self.pageSize)
        let messagesNeeded = self.itemsOffset - nextWindowOffset
        if messagesNeeded > 0 {
            self.generateItems(messagesNeeded, position: .top)
        }
        let newItemsCount = previousWindowOffset - nextWindowOffset
        self.windowOffset = nextWindowOffset
        self.windowCount = previousWindowCount + newItemsCount
    }

    public func loadNext() {
        guard self.items.count > 0 else { return }
        let itemCountAfterWindow = self.itemsOffset + self.items.count - self.windowOffset - self.windowCount
        self.windowCount += min(self.pageSize, itemCountAfterWindow)
    }

    @discardableResult
    public func adjustWindow(focusPosition: Double, maxWindowSize: Int) -> Bool {
        assert(0 <= focusPosition && focusPosition <= 1, "")
        guard 0 <= focusPosition && focusPosition <= 1 else {
            assert(false, "focus should be in the [0, 1] interval")
            return false
        }
        let sizeDiff = self.windowCount - maxWindowSize
        guard sizeDiff > 0 else { return false }
        self.windowOffset +=  Int(focusPosition * Double(sizeDiff))
        self.windowCount = maxWindowSize
        return true
    }

    @discardableResult
    func replaceItem(withNewItem item: Element, where predicate: (Element) -> Bool) -> Bool {
        guard let index = self.items.firstIndex(where: predicate) else { return false }
        self.items[index] = item
        return true
    }
}

class DemoChatMessageFactory {
    private static let demoText =
        "Lorem ipsum dolor sit amet 😇, https://github.com/badoo/Chatto consectetur adipiscing elit , sed do eiusmod tempor incididunt 07400000000 📞 ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore https://github.com/badoo/Chatto eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 07400000000 non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

    class func makeRandomMessage(_ uid: String) -> MessageModelProtocol {
        let isIncoming: Bool = arc4random_uniform(100) % 2 == 0
        return self.makeRandomMessage(uid, isIncoming: isIncoming)
    }

    class func makeRandomMessage(_ uid: String, isIncoming: Bool) -> MessageModelProtocol {
        self.makeRandomTextMessage(uid, isIncoming: isIncoming)
//        if arc4random_uniform(100) % 2 == 0 {
//            return self.makeRandomTextMessage(uid, isIncoming: isIncoming)
//        } else {
//            return self.makeRandomPhotoMessage(uid, isIncoming: isIncoming)
//        }
    }

    class func makeTextMessage(_ uid: String, text: String, isIncoming: Bool) -> DemoTextMessageModel {
        let messageModel = self.makeMessageModel(uid, isIncoming: isIncoming, type: TextMessageModel<MessageModel>.chatItemType)
        let textMessageModel = DemoTextMessageModel(messageModel: messageModel, text: text)
        return textMessageModel
    }

//    class func makePhotoMessage(_ uid: String, image: UIImage, size: CGSize, isIncoming: Bool) -> DemoPhotoMessageModel {
//        let messageModel = self.makeMessageModel(uid, isIncoming: isIncoming, type: PhotoMessageModel<MessageModel>.chatItemType)
//        let photoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: size, image: image)
//        return photoMessageModel
//    }

//    static func makeCompoundMessage(uid: String = UUID().uuidString, text: String? = nil, imageName: String? = nil, isIncoming: Bool) -> DemoCompoundMessageModel {
//        let messageModel = self.makeMessageModel(uid,
//                                                 isIncoming: isIncoming,
//                                                 type: .compoundItemType)
//        let text = text ?? (isIncoming ? "Hello, how are you" : "I'm good, thanks, how about yourself?")
//        let imageName = imageName ?? (isIncoming ? "pic-test-1" : "pic-test-2")
//        let image = UIImage(named: imageName)!
//        return DemoCompoundMessageModel(text: text,
//                                        image: image,
//                                        messageModel: messageModel)
//    }

    private class func makeRandomTextMessage(_ uid: String, isIncoming: Bool) -> DemoTextMessageModel {
        let incomingText: String = isIncoming ? "incoming" : "outgoing"
        let maxText = self.demoText
        let length: Int = 10 + Int(arc4random_uniform(300))
        let text = "\(String(maxText[..<maxText.index(maxText.startIndex, offsetBy: length)]))\n\n\(incomingText)\n#\(uid)"
        return self.makeTextMessage(uid, text: text, isIncoming: isIncoming)
    }

//    private class func makeRandomPhotoMessage(_ uid: String, isIncoming: Bool) -> DemoPhotoMessageModel {
//        var imageSize = CGSize.zero
//        switch arc4random_uniform(100) % 3 {
//        case 0:
//            imageSize = CGSize(width: 400, height: 300)
//        case 1:
//            imageSize = CGSize(width: 300, height: 400)
//        default:
//            imageSize = CGSize(width: 300, height: 300)
//        }
//
//        var imageName: String
//        switch arc4random_uniform(100) % 3 {
//        case 0:
//            imageName = "pic-test-1"
//        case 1:
//            imageName = "pic-test-2"
//        default:
//            imageName = "pic-test-3"
//        }
//        return self.makePhotoMessage(uid, image: UIImage(named: imageName)!, size: imageSize, isIncoming: isIncoming)
//    }

    private class func makeMessageModel(_ uid: String, isIncoming: Bool, type: String) -> MessageModel {
        let senderId = isIncoming ? "1" : "2"
        let messageStatus = isIncoming || arc4random_uniform(100) % 3 == 0 ? MessageStatus.success : .failed
        return MessageModel(uid: uid, senderId: senderId, type: type, isIncoming: isIncoming, date: Date(), status: messageStatus)
    }
}

extension TextMessageModel {
    static var chatItemType: ChatItemType {
        return "text"
    }
}

public class DemoChatMessageSender {

    public var onMessageChanged: ((_ message: DemoMessageModelProtocol) -> Void)?

    public func sendMessages(_ messages: [DemoMessageModelProtocol]) {
        for message in messages {
            self.fakeMessageStatus(message)
        }
    }

    public func sendMessage(_ message: DemoMessageModelProtocol) {
        self.fakeMessageStatus(message)
    }

    private func fakeMessageStatus(_ message: DemoMessageModelProtocol) {
        switch message.status {
        case .success:
            break
        case .failed:
            self.updateMessage(message, status: .sending)
            self.fakeMessageStatus(message)
        case .sending:
            switch arc4random_uniform(100) % 5 {
            case 0:
                if arc4random_uniform(100) % 2 == 0 {
                    self.updateMessage(message, status: .failed)
                } else {
                    self.updateMessage(message, status: .success)
                }
            default:
                let delaySeconds: Double = Double(arc4random_uniform(1200)) / 1000.0
                let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.fakeMessageStatus(message)
                }
            }
        }
    }

    private func updateMessage(_ message: DemoMessageModelProtocol, status: MessageStatus) {
        if message.status != status {
            message.status = status
            self.notifyMessageChanged(message)
        }
    }

    private func notifyMessageChanged(_ message: DemoMessageModelProtocol) {
        self.onMessageChanged?(message)
    }
}

public protocol MessagesSelectorDelegate: class {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol)
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol)
}

public protocol MessagesSelectorProtocol: class {
    var delegate: MessagesSelectorDelegate? { get set }
    var isActive: Bool { get set }
    func canSelectMessage(_ message: MessageModelProtocol) -> Bool
    func isMessageSelected(_ message: MessageModelProtocol) -> Bool
    func selectMessage(_ message: MessageModelProtocol)
    func deselectMessage(_ message: MessageModelProtocol)
    func selectedMessages() -> [MessageModelProtocol]
}

final class DemoChatItemsDecorator: ChatItemsDecoratorProtocol {
    private struct Constants {
        static let shortSeparation: CGFloat = 3
        static let normalSeparation: CGFloat = 10
        static let timeIntervalThresholdToIncreaseSeparation: TimeInterval = 120
    }

    private let messagesSelector: MessagesSelectorProtocol
    init(messagesSelector: MessagesSelectorProtocol) {
        self.messagesSelector = messagesSelector
    }

    func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
        var decoratedChatItems = [DecoratedChatItem]()
        let calendar = Calendar.current

        for (index, chatItem) in chatItems.enumerated() {
            let next: ChatItemProtocol? = (index + 1 < chatItems.count) ? chatItems[index + 1] : nil
            let prev: ChatItemProtocol? = (index > 0) ? chatItems[index - 1] : nil

            let bottomMargin = self.separationAfterItem(chatItem, next: next)
            var showsTail = false
            var additionalItems =  [DecoratedChatItem]()
            var addTimeSeparator = false
            var isSelected = false
            var isShowingSelectionIndicator = false

            if let currentMessage = chatItem as? MessageModelProtocol {
                if let nextMessage = next as? MessageModelProtocol {
                    showsTail = currentMessage.senderId != nextMessage.senderId
                } else {
                    showsTail = true
                }

                if let previousMessage = prev as? MessageModelProtocol {
                    addTimeSeparator = !calendar.isDate(currentMessage.date, inSameDayAs: previousMessage.date)
                } else {
                    addTimeSeparator = true
                }

                if self.showsStatusForMessage(currentMessage) {
                    additionalItems.append(
                        DecoratedChatItem(
                            chatItem: SendingStatusModel(uid: "\(currentMessage.uid)-decoration-status", status: currentMessage.status),
                            decorationAttributes: nil)
                    )
                }

//                if addTimeSeparator {
//                    let dateTimeStamp = DecoratedChatItem(chatItem: TimeSeparatorModel(uid: "\(currentMessage.uid)-time-separator", date: currentMessage.date.toWeekDayAndDateString()), decorationAttributes: nil)
//                    decoratedChatItems.append(dateTimeStamp)
//                }

                isSelected = self.messagesSelector.isMessageSelected(currentMessage)
                isShowingSelectionIndicator = self.messagesSelector.isActive && self.messagesSelector.canSelectMessage(currentMessage)
            }

            let messageDecorationAttributes = BaseMessageDecorationAttributes(
                canShowFailedIcon: true,
                isShowingTail: showsTail,
                isShowingAvatar: showsTail,
                isShowingSelectionIndicator: isShowingSelectionIndicator,
                isSelected: isSelected
            )

            decoratedChatItems.append(
                DecoratedChatItem(
                    chatItem: chatItem,
                    decorationAttributes: ChatItemDecorationAttributes(bottomMargin: bottomMargin, messageDecorationAttributes: messageDecorationAttributes)
                )
            )
            decoratedChatItems.append(contentsOf: additionalItems)
        }

        return decoratedChatItems
    }

    private func separationAfterItem(_ current: ChatItemProtocol?, next: ChatItemProtocol?) -> CGFloat {
        guard let nexItem = next else { return 0 }
        guard let currentMessage = current as? MessageModelProtocol else { return Constants.normalSeparation }
        guard let nextMessage = nexItem as? MessageModelProtocol else { return Constants.normalSeparation }

        if self.showsStatusForMessage(currentMessage) {
            return 0
        } else if currentMessage.senderId != nextMessage.senderId {
            return Constants.normalSeparation
        } else if nextMessage.date.timeIntervalSince(currentMessage.date) > Constants.timeIntervalThresholdToIncreaseSeparation {
            return Constants.normalSeparation
        } else {
            return Constants.shortSeparation
        }
    }

    private func showsStatusForMessage(_ message: MessageModelProtocol) -> Bool {
        return message.status == .failed || message.status == .sending
    }
}

class SendingStatusModel: ChatItemProtocol {
    let uid: String
    static var chatItemType: ChatItemType {
        return "decoration-status"
    }

    var type: String { return SendingStatusModel.chatItemType }
    let status: MessageStatus

    init (uid: String, status: MessageStatus) {
        self.uid = uid
        self.status = status
    }
}

public class BaseMessagesSelector: MessagesSelectorProtocol {

    public weak var delegate: MessagesSelectorDelegate?

    public var isActive = false {
        didSet {
            guard oldValue != self.isActive else { return }
            if self.isActive {
                self.selectedMessagesDictionary.removeAll()
            }
        }
    }

    public func canSelectMessage(_ message: MessageModelProtocol) -> Bool {
        return true
    }

    public func isMessageSelected(_ message: MessageModelProtocol) -> Bool {
        return self.selectedMessagesDictionary[message.uid] != nil
    }

    public func selectMessage(_ message: MessageModelProtocol) {
        self.selectedMessagesDictionary[message.uid] = message
        self.delegate?.messagesSelector(self, didSelectMessage: message)
    }

    public func deselectMessage(_ message: MessageModelProtocol) {
        self.selectedMessagesDictionary[message.uid] = nil
        self.delegate?.messagesSelector(self, didDeselectMessage: message)
    }

    public func selectedMessages() -> [MessageModelProtocol] {
        return Array(self.selectedMessagesDictionary.values)
    }

    // MARK: - Private

    private var selectedMessagesDictionary = [String: MessageModelProtocol]()
}
