import Foundation

/// The type of a chat message.
enum MessageType: String, Codable, Sendable {
    case text
    case image
    case offer
    case system
    case location
}

/// Represents a single chat message in a conversation.
struct Message: Codable, Hashable, Identifiable, Sendable {
    let id: String
    let conversationID: String
    let senderID: String
    let senderName: String
    let type: MessageType
    let content: String
    var imageURL: String?
    var offerAmount: Int?
    var isRead: Bool
    let createdAt: Date

    /// Whether this message was sent by the current user.
    var isMine: Bool {
        senderID == "current-user-id"
    }

    init(
        id: String,
        conversationID: String,
        senderID: String,
        senderName: String,
        type: MessageType = .text,
        content: String,
        imageURL: String? = nil,
        offerAmount: Int? = nil,
        isRead: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.conversationID = conversationID
        self.senderID = senderID
        self.senderName = senderName
        self.type = type
        self.content = content
        self.imageURL = imageURL
        self.offerAmount = offerAmount
        self.isRead = isRead
        self.createdAt = createdAt
    }
}
