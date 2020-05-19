import MessageKit

final class DataProvider {
    
    static let shared = DataProvider()
    
    let meUser = User(senderId: "0", displayName: "Me")
    let managerUser = User(senderId: "b1", displayName: "Manager")
    
    lazy var messages = [
        MockMessage(text: "wqiuehqwiueh\nweqe", user: meUser, messageId: UUID().uuidString, date: Date()),
        MockMessage(text: "12312", user: meUser, messageId: UUID().uuidString, date: Date().addingTimeInterval(3600)),
        MockMessage(text: "uiui", user: managerUser, messageId: UUID().uuidString, date: Date()),
        MockMessage(text: "wqiuehqwiueh\nweqe", user: managerUser, messageId: UUID().uuidString, date: Date()),
        MockMessage(text: "12312", user: meUser, messageId: UUID().uuidString, date: Date()),
    ]
    
}

struct User: SenderType {
    let senderId: String
    let displayName: String
}

struct MockMessage: MessageType {
    
    let messageId: String
    let sentDate: Date
    let kind: MessageKind
    let user: User
    
    var sender: SenderType {
        return user
    }
    
    private init(kind: MessageKind, user: User, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, user: User, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }
    
}


extension UIColor {
    static let primaryColor = UIColor.magenta
}
