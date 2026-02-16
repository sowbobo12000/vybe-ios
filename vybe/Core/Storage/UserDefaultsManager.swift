import Foundation

/// A type-safe wrapper around UserDefaults for non-sensitive app preferences.
enum UserDefaultsManager {
    nonisolated(unsafe) private static let defaults = UserDefaults.standard

    // MARK: - Onboarding

    static var hasOnboarded: Bool {
        get { defaults.bool(forKey: Constants.StorageKeys.hasOnboarded) }
        set { defaults.set(newValue, forKey: Constants.StorageKeys.hasOnboarded) }
    }

    // MARK: - Theme

    static var preferredTheme: String? {
        get { defaults.string(forKey: Constants.StorageKeys.preferredTheme) }
        set { defaults.set(newValue, forKey: Constants.StorageKeys.preferredTheme) }
    }

    // MARK: - Search History

    static var searchHistory: [String] {
        get { defaults.stringArray(forKey: Constants.StorageKeys.searchHistory) ?? [] }
        set {
            let limited = Array(newValue.prefix(Constants.UI.maxSearchHistoryItems))
            defaults.set(limited, forKey: Constants.StorageKeys.searchHistory)
        }
    }

    static func addSearchQuery(_ query: String) {
        var history = searchHistory
        history.removeAll { $0 == query }
        history.insert(query, at: 0)
        searchHistory = history
    }

    static func clearSearchHistory() {
        searchHistory = []
    }

    // MARK: - Last Sync

    static var lastSyncDate: Date? {
        get { defaults.object(forKey: Constants.StorageKeys.lastSyncDate) as? Date }
        set { defaults.set(newValue, forKey: Constants.StorageKeys.lastSyncDate) }
    }

    // MARK: - Reset

    static func resetAll() {
        let domain = Bundle.main.bundleIdentifier ?? Constants.App.bundleID
        defaults.removePersistentDomain(forName: domain)
    }
}
