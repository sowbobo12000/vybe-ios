import Foundation

/// The status of an offer on a listing.
enum OfferStatus: String, Codable, Sendable {
    case pending
    case accepted
    case declined
    case countered
    case withdrawn
    case expired
}

/// Represents an offer made on a listing.
struct Offer: Codable, Hashable, Identifiable, Sendable {
    let id: String
    let listingID: String
    let listingTitle: String
    let listingThumbnailURL: String?
    let listingPrice: Int
    let buyerID: String
    let buyerName: String
    let buyerAvatarURL: String?
    let sellerID: String
    let sellerName: String
    let sellerAvatarURL: String?
    let amount: Int  // offer amount in cents
    var status: OfferStatus
    var message: String?
    var counterAmount: Int?  // counter-offer amount in cents
    let createdAt: Date
    var updatedAt: Date
    var expiresAt: Date?

    var isExpired: Bool {
        if let expiresAt {
            return Date() > expiresAt
        }
        return false
    }

    init(
        id: String,
        listingID: String,
        listingTitle: String,
        listingThumbnailURL: String? = nil,
        listingPrice: Int,
        buyerID: String,
        buyerName: String,
        buyerAvatarURL: String? = nil,
        sellerID: String,
        sellerName: String,
        sellerAvatarURL: String? = nil,
        amount: Int,
        status: OfferStatus = .pending,
        message: String? = nil,
        counterAmount: Int? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        expiresAt: Date? = nil
    ) {
        self.id = id
        self.listingID = listingID
        self.listingTitle = listingTitle
        self.listingThumbnailURL = listingThumbnailURL
        self.listingPrice = listingPrice
        self.buyerID = buyerID
        self.buyerName = buyerName
        self.buyerAvatarURL = buyerAvatarURL
        self.sellerID = sellerID
        self.sellerName = sellerName
        self.sellerAvatarURL = sellerAvatarURL
        self.amount = amount
        self.status = status
        self.message = message
        self.counterAmount = counterAmount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.expiresAt = expiresAt
    }
}
