import Foundation

/// Represents a chat conversation between two users, typically regarding a listing.
struct Conversation: Codable, Hashable, Identifiable, Sendable {
    let id: String
    let participantIDs: [String]
    let otherUser: UserSummary
    var listingID: String?
    var listingTitle: String?
    var listingThumbnailURL: String?
    var listingPrice: Int?
    var lastMessage: String?
    var lastMessageAt: Date?
    var unreadCount: Int
    var isArchived: Bool

    init(
        id: String,
        participantIDs: [String],
        otherUser: UserSummary,
        listingID: String? = nil,
        listingTitle: String? = nil,
        listingThumbnailURL: String? = nil,
        listingPrice: Int? = nil,
        lastMessage: String? = nil,
        lastMessageAt: Date? = nil,
        unreadCount: Int = 0,
        isArchived: Bool = false
    ) {
        self.id = id
        self.participantIDs = participantIDs
        self.otherUser = otherUser
        self.listingID = listingID
        self.listingTitle = listingTitle
        self.listingThumbnailURL = listingThumbnailURL
        self.listingPrice = listingPrice
        self.lastMessage = lastMessage
        self.lastMessageAt = lastMessageAt
        self.unreadCount = unreadCount
        self.isArchived = isArchived
    }
}
