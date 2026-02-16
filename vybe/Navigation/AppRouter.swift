import SwiftUI

/// Central navigation coordinator that manages the navigation stack paths
/// for each tab and handles deep links.
@Observable
@MainActor
final class AppRouter {
    /// The currently selected tab
    var selectedTab: Tab = .home

    /// Navigation paths for each tab
    var homePath = NavigationPath()
    var searchPath = NavigationPath()
    var chatPath = NavigationPath()
    var communityPath = NavigationPath()
    var profilePath = NavigationPath()

    /// Auth sheet presentation
    var showAuthSheet = false
    var showCreateListing = false

    /// Available tabs
    enum Tab: String, CaseIterable {
        case home = "Home"
        case search = "Search"
        case chat = "Chat"
        case communities = "Communities"
        case profile = "Profile"

        var icon: String {
            switch self {
            case .home: return "house"
            case .search: return "magnifyingglass"
            case .chat: return "bubble.left.and.bubble.right"
            case .communities: return "person.3"
            case .profile: return "person.circle"
            }
        }

        var selectedIcon: String {
            switch self {
            case .home: return "house.fill"
            case .search: return "magnifyingglass"
            case .chat: return "bubble.left.and.bubble.right.fill"
            case .communities: return "person.3.fill"
            case .profile: return "person.circle.fill"
            }
        }
    }

    // MARK: - Navigation Actions

    func navigate(to route: Route) {
        switch selectedTab {
        case .home: homePath.append(route)
        case .search: searchPath.append(route)
        case .chat: chatPath.append(route)
        case .communities: communityPath.append(route)
        case .profile: profilePath.append(route)
        }
    }

    func navigateToTab(_ tab: Tab) {
        selectedTab = tab
    }

    func popToRoot() {
        switch selectedTab {
        case .home: homePath = NavigationPath()
        case .search: searchPath = NavigationPath()
        case .chat: chatPath = NavigationPath()
        case .communities: communityPath = NavigationPath()
        case .profile: profilePath = NavigationPath()
        }
    }

    func pop() {
        switch selectedTab {
        case .home:
            if !homePath.isEmpty { homePath.removeLast() }
        case .search:
            if !searchPath.isEmpty { searchPath.removeLast() }
        case .chat:
            if !chatPath.isEmpty { chatPath.removeLast() }
        case .communities:
            if !communityPath.isEmpty { communityPath.removeLast() }
        case .profile:
            if !profilePath.isEmpty { profilePath.removeLast() }
        }
    }

    /// Returns a binding to the current tab's navigation path
    var currentPath: NavigationPath {
        get {
            switch selectedTab {
            case .home: return homePath
            case .search: return searchPath
            case .chat: return chatPath
            case .communities: return communityPath
            case .profile: return profilePath
            }
        }
        set {
            switch selectedTab {
            case .home: homePath = newValue
            case .search: searchPath = newValue
            case .chat: chatPath = newValue
            case .communities: communityPath = newValue
            case .profile: profilePath = newValue
            }
        }
    }
}
