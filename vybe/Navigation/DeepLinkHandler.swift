import Foundation

/// Handles deep links and universal links, converting URLs into typed Route values.
@MainActor
final class DeepLinkHandler {
    private let router: AppRouter

    init(router: AppRouter) {
        self.router = router
    }

    /// Parse a URL and navigate to the appropriate screen.
    /// Supports schemes like: vybe://listing/123, vybe://profile/user-1, vybe://chat/conv-1
    func handle(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }

        let pathComponents = components.path
            .split(separator: "/")
            .map(String.init)

        guard let firstComponent = pathComponents.first else { return }

        switch firstComponent {
        case "listing":
            if let id = pathComponents.dropFirst().first {
                router.selectedTab = .home
                router.navigate(to: .listingDetail(id: id))
            }
        case "profile":
            if let userID = pathComponents.dropFirst().first {
                router.selectedTab = .profile
                router.navigate(to: .profile(userID: userID))
            }
        case "chat":
            if let conversationID = pathComponents.dropFirst().first {
                router.selectedTab = .chat
                router.navigate(to: .chatDetail(conversationID: conversationID))
            }
        case "offer":
            if let offerID = pathComponents.dropFirst().first {
                router.navigate(to: .offerDetail(offerID: offerID))
            }
        case "community":
            if let communityID = pathComponents.dropFirst().first {
                router.selectedTab = .communities
                router.navigate(to: .communityDetail(id: communityID))
            }
        case "search":
            let query = components.queryItems?.first(where: { $0.name == "q" })?.value ?? ""
            router.selectedTab = .search
            if !query.isEmpty {
                router.navigate(to: .searchResults(query: query))
            }
        default:
            break
        }
    }
}
