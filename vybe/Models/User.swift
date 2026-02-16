import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var id: String
    var username: String
    var displayName: String
    var email: String?
    var phone: String?
    var avatarURL: String?
    var bio: String?
    var location: String?
    var latitude: Double?
    var longitude: Double?
    var mannerTemperature: Double
    var totalListings: Int
    var totalSales: Int
    var totalReviews: Int
    var averageRating: Double
    var isVerified: Bool
    var joinedAt: Date
    var lastActiveAt: Date

    init(
        id: String,
        username: String,
        displayName: String,
        email: String? = nil,
        phone: String? = nil,
        avatarURL: String? = nil,
        bio: String? = nil,
        location: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        mannerTemperature: Double = 36.5,
        totalListings: Int = 0,
        totalSales: Int = 0,
        totalReviews: Int = 0,
        averageRating: Double = 0.0,
        isVerified: Bool = false,
        joinedAt: Date = Date(),
        lastActiveAt: Date = Date()
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.email = email
        self.phone = phone
        self.avatarURL = avatarURL
        self.bio = bio
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.mannerTemperature = mannerTemperature
        self.totalListings = totalListings
        self.totalSales = totalSales
        self.totalReviews = totalReviews
        self.averageRating = averageRating
        self.isVerified = isVerified
        self.joinedAt = joinedAt
        self.lastActiveAt = lastActiveAt
    }
}

/// A lightweight, non-persisted user reference for use in views and API responses.
struct UserSummary: Codable, Hashable, Identifiable, Sendable {
    let id: String
    let username: String
    let displayName: String
    var avatarURL: String?
    var location: String?
    var mannerTemperature: Double
    var isVerified: Bool
    var isOnline: Bool

    init(
        id: String,
        username: String,
        displayName: String,
        avatarURL: String? = nil,
        location: String? = nil,
        mannerTemperature: Double = 36.5,
        isVerified: Bool = false,
        isOnline: Bool = false
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.avatarURL = avatarURL
        self.location = location
        self.mannerTemperature = mannerTemperature
        self.isVerified = isVerified
        self.isOnline = isOnline
    }
}
