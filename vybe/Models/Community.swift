import Foundation

/// Represents a community group in the marketplace.
struct Community: Codable, Hashable, Identifiable, Sendable {
    let id: String
    let name: String
    let description: String
    var iconURL: String?
    var bannerURL: String?
    let category: String
    var memberCount: Int
    var listingCount: Int
    var isJoined: Bool
    var isFeatured: Bool
    let createdAt: Date

    init(
        id: String,
        name: String,
        description: String,
        iconURL: String? = nil,
        bannerURL: String? = nil,
        category: String = "General",
        memberCount: Int = 0,
        listingCount: Int = 0,
        isJoined: Bool = false,
        isFeatured: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconURL = iconURL
        self.bannerURL = bannerURL
        self.category = category
        self.memberCount = memberCount
        self.listingCount = listingCount
        self.isJoined = isJoined
        self.isFeatured = isFeatured
        self.createdAt = createdAt
    }
}
