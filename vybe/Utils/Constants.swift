import Foundation

/// App-wide constants and configuration values.
enum Constants {
    // MARK: - API Configuration

    enum API {
        static let baseURL = "https://api.vybe.market/v1"
        static let websocketURL = "wss://ws.vybe.market/v1"
        static let timeoutInterval: TimeInterval = 30
        static let maxRetries = 3
    }

    // MARK: - App Configuration

    enum App {
        static let name = "vybe"
        static let bundleID = "market.vybe.ios"
        static let appStoreID = ""
        static let supportEmail = "support@vybe.market"
        static let termsURL = "https://vybe.market/terms"
        static let privacyURL = "https://vybe.market/privacy"
    }

    // MARK: - Storage Keys

    enum StorageKeys {
        static let accessToken = "vybe_access_token"
        static let refreshToken = "vybe_refresh_token"
        static let userID = "vybe_user_id"
        static let hasOnboarded = "vybe_has_onboarded"
        static let lastSyncDate = "vybe_last_sync_date"
        static let preferredTheme = "vybe_preferred_theme"
        static let searchHistory = "vybe_search_history"
        static let recentLocations = "vybe_recent_locations"
    }

    // MARK: - UI Configuration

    enum UI {
        static let maxImageSize: Int = 5 * 1024 * 1024  // 5MB
        static let maxImagesPerListing = 10
        static let maxTitleLength = 100
        static let maxDescriptionLength = 2000
        static let maxMessageLength = 1000
        static let maxSearchHistoryItems = 20
        static let listingGridColumns = 2
        static let pageSize = 20
        static let debounceDelay: TimeInterval = 0.3
    }

    // MARK: - Location

    enum Location {
        static let defaultLatitude = 37.7749   // San Francisco
        static let defaultLongitude = -122.4194
        static let defaultRadiusMiles = 25.0
        static let maxRadiusMiles = 100.0
    }

    // MARK: - Manner Temperature

    enum MannerTemp {
        static let initial: Double = 36.5
        static let min: Double = 0.0
        static let max: Double = 99.0
    }
}
