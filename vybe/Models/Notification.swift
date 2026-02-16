import Foundation

/// The type of notification.
enum NotificationType: String, Codable, Sendable {
    case newOffer
    case offerAccepted
    case offerDeclined
    case offerCountered
    case newMessage
    case listingLiked
    case listingSold
    case priceDropped
    case communityPost
    case systemAlert
}

/// Represents an in-app notification.
struct AppNotification: Codable, Hashable, Identifiable, Sendable {
    let id: String
    let type: NotificationType
    let title: String
    let body: String
    var imageURL: String?
    var referenceID: String?  // listing ID, offer ID, etc.
    var isRead: Bool
    let createdAt: Date

    var icon: String {
        switch type {
        case .newOffer: return "hand.raised.fill"
        case .offerAccepted: return "checkmark.circle.fill"
        case .offerDeclined: return "xmark.circle.fill"
        case .offerCountered: return "arrow.left.arrow.right"
        case .newMessage: return "bubble.left.fill"
        case .listingLiked: return "heart.fill"
        case .listingSold: return "bag.fill"
        case .priceDropped: return "arrow.down.circle.fill"
        case .communityPost: return "person.3.fill"
        case .systemAlert: return "bell.fill"
        }
    }

    var accentColor: String {
        switch type {
        case .newOffer, .offerCountered: return "#B78AF7"
        case .offerAccepted, .listingSold: return "#6EE7B7"
        case .offerDeclined: return "#FCA5A5"
        case .newMessage: return "#67E8F9"
        case .listingLiked: return "#F0ABFC"
        case .priceDropped: return "#FCD34D"
        case .communityPost: return "#FDA4AF"
        case .systemAlert: return "#8086B0"
        }
    }

    init(
        id: String,
        type: NotificationType,
        title: String,
        body: String,
        imageURL: String? = nil,
        referenceID: String? = nil,
        isRead: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.imageURL = imageURL
        self.referenceID = referenceID
        self.isRead = isRead
        self.createdAt = createdAt
    }
}
