import Foundation
import SwiftData

/// The possible states of a marketplace listing.
enum ListingStatus: String, Codable, Sendable {
    case active
    case reserved
    case sold
    case hidden
    case deleted
}

/// The condition of a listed item.
enum ListingCondition: String, Codable, CaseIterable, Sendable {
    case brandNew = "Brand New"
    case likeNew = "Like New"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
}

/// The categories available in the marketplace.
enum ListingCategory: String, Codable, CaseIterable, Sendable {
    case electronics = "Electronics"
    case fashion = "Fashion"
    case home = "Home & Garden"
    case sports = "Sports"
    case vehicles = "Vehicles"
    case books = "Books"
    case music = "Music"
    case collectibles = "Collectibles"
    case gaming = "Gaming"
    case beauty = "Beauty"
    case toys = "Toys"
    case other = "Other"

    var icon: String {
        switch self {
        case .electronics: return "desktopcomputer"
        case .fashion: return "tshirt"
        case .home: return "house"
        case .sports: return "sportscourt"
        case .vehicles: return "car"
        case .books: return "book"
        case .music: return "music.note"
        case .collectibles: return "star"
        case .gaming: return "gamecontroller"
        case .beauty: return "sparkles"
        case .toys: return "puzzlepiece"
        case .other: return "ellipsis.circle"
        }
    }
}

@Model
final class Listing: @unchecked Sendable {
    @Attribute(.unique) var id: String
    var title: String
    var itemDescription: String
    var price: Int  // in cents
    var originalPrice: Int?  // in cents, for showing discounts
    var currency: String
    var category: String
    var condition: String
    var imageURLs: [String]
    var sellerID: String
    var sellerName: String
    var sellerAvatarURL: String?
    var sellerMannerTemp: Double
    var sellerLocation: String?
    var status: String
    var viewCount: Int
    var likeCount: Int
    var offerCount: Int
    var isLiked: Bool
    var isFeatured: Bool
    var latitude: Double?
    var longitude: Double?
    var location: String?
    var distanceText: String?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: String,
        title: String,
        itemDescription: String,
        price: Int,
        originalPrice: Int? = nil,
        currency: String = "USD",
        category: String = ListingCategory.other.rawValue,
        condition: String = ListingCondition.good.rawValue,
        imageURLs: [String] = [],
        sellerID: String,
        sellerName: String,
        sellerAvatarURL: String? = nil,
        sellerMannerTemp: Double = 36.5,
        sellerLocation: String? = nil,
        status: String = ListingStatus.active.rawValue,
        viewCount: Int = 0,
        likeCount: Int = 0,
        offerCount: Int = 0,
        isLiked: Bool = false,
        isFeatured: Bool = false,
        latitude: Double? = nil,
        longitude: Double? = nil,
        location: String? = nil,
        distanceText: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.itemDescription = itemDescription
        self.price = price
        self.originalPrice = originalPrice
        self.currency = currency
        self.category = category
        self.condition = condition
        self.imageURLs = imageURLs
        self.sellerID = sellerID
        self.sellerName = sellerName
        self.sellerAvatarURL = sellerAvatarURL
        self.sellerMannerTemp = sellerMannerTemp
        self.sellerLocation = sellerLocation
        self.status = status
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.offerCount = offerCount
        self.isLiked = isLiked
        self.isFeatured = isFeatured
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
        self.distanceText = distanceText
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

/// Lightweight listing summary for API responses and list views.
struct ListingSummary: Codable, Hashable, Identifiable, Sendable {
    let id: String
    let title: String
    let price: Int
    var originalPrice: Int?
    let currency: String
    let category: String
    let condition: String
    let thumbnailURL: String?
    let imageURLs: [String]
    let sellerID: String
    let sellerName: String
    var sellerAvatarURL: String?
    var sellerMannerTemp: Double
    var sellerLocation: String?
    let status: String
    var viewCount: Int
    var likeCount: Int
    var offerCount: Int
    var isLiked: Bool
    var isFeatured: Bool
    var location: String?
    var distanceText: String?
    var itemDescription: String
    let createdAt: Date

    init(
        id: String,
        title: String,
        price: Int,
        originalPrice: Int? = nil,
        currency: String = "USD",
        category: String = ListingCategory.other.rawValue,
        condition: String = ListingCondition.good.rawValue,
        thumbnailURL: String? = nil,
        imageURLs: [String] = [],
        sellerID: String,
        sellerName: String,
        sellerAvatarURL: String? = nil,
        sellerMannerTemp: Double = 36.5,
        sellerLocation: String? = nil,
        status: String = ListingStatus.active.rawValue,
        viewCount: Int = 0,
        likeCount: Int = 0,
        offerCount: Int = 0,
        isLiked: Bool = false,
        isFeatured: Bool = false,
        location: String? = nil,
        distanceText: String? = nil,
        itemDescription: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.originalPrice = originalPrice
        self.currency = currency
        self.category = category
        self.condition = condition
        self.thumbnailURL = thumbnailURL
        self.imageURLs = imageURLs
        self.sellerID = sellerID
        self.sellerName = sellerName
        self.sellerAvatarURL = sellerAvatarURL
        self.sellerMannerTemp = sellerMannerTemp
        self.sellerLocation = sellerLocation
        self.status = status
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.offerCount = offerCount
        self.isLiked = isLiked
        self.isFeatured = isFeatured
        self.location = location
        self.distanceText = distanceText
        self.itemDescription = itemDescription
        self.createdAt = createdAt
    }
}
