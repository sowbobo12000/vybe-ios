import Foundation

/// Type-safe route definitions for NavigationStack.
enum Route: Hashable {
    // Listings
    case listingDetail(id: String)
    case createListing
    case editListing(id: String)

    // User
    case profile(userID: String)
    case editProfile

    // Chat
    case chatDetail(conversationID: String)
    case newChat(userID: String, listingID: String?)

    // Offers
    case offerDetail(offerID: String)
    case makeOffer(listingID: String)

    // Auth
    case login
    case signup
    case otpVerification(phone: String)

    // Communities
    case communityDetail(id: String)

    // Search
    case searchResults(query: String)
    case categoryResults(category: String)

    // Settings
    case settings
    case notificationSettings
    case privacySettings
    case about
}
