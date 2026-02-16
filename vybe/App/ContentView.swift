import SwiftUI

/// Root view with custom tab bar navigation.
/// Provides a glass morphism tab bar at the bottom and manages
/// NavigationStack for each tab with type-safe routing.
struct ContentView: View {
    @Environment(AppRouter.self) private var router
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        @Bindable var router = router

        ZStack(alignment: .bottom) {
            // Tab Content
            TabView(selection: $router.selectedTab) {
                homeTab
                    .tag(AppRouter.Tab.home)
                searchTab
                    .tag(AppRouter.Tab.search)
                chatTab
                    .tag(AppRouter.Tab.chat)
                communitiesTab
                    .tag(AppRouter.Tab.communities)
                profileTab
                    .tag(AppRouter.Tab.profile)
            }
            .toolbar(.hidden, for: .tabBar)

            // Custom Glass Tab Bar
            customTabBar
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $router.showAuthSheet) {
            LoginView()
        }
        .sheet(isPresented: $router.showCreateListing) {
            NavigationStack {
                CreateListingView()
            }
        }
    }

    // MARK: - Tab Views

    private var homeTab: some View {
        NavigationStack(path: $router.homePath) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var searchTab: some View {
        NavigationStack(path: $router.searchPath) {
            SearchView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var chatTab: some View {
        NavigationStack(path: $router.chatPath) {
            ConversationsView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var communitiesTab: some View {
        NavigationStack(path: $router.communityPath) {
            CommunitiesView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var profileTab: some View {
        NavigationStack(path: $router.profilePath) {
            ProfileView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    // MARK: - Route Destination

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .listingDetail(let id):
            ListingDetailView(listingID: id)
        case .createListing:
            CreateListingView()
        case .profile(let userID):
            ProfileView(userID: userID)
        case .chatDetail(let conversationID):
            ChatDetailView(conversationID: conversationID)
        case .searchResults(let query):
            SearchView(initialQuery: query)
        case .communityDetail(let id):
            CommunitiesView(highlightedCommunityID: id)
        default:
            Text("Coming Soon")
                .font(VybeTypography.heading2)
                .foregroundStyle(VybeColors.foreground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(VybeColors.background)
        }
    }

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppRouter.Tab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, VybeSpacing.xs)
        .padding(.top, VybeSpacing.xs)
        .padding(.bottom, VybeSpacing.xxs)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay {
                    Rectangle()
                        .fill(VybeColors.surface.opacity(0.5))
                }
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(VybeColors.borderGlow.opacity(0.3))
                        .frame(height: 0.5)
                }
                .ignoresSafeArea()
        }
    }

    private func tabButton(for tab: AppRouter.Tab) -> some View {
        Button {
            if router.selectedTab == tab {
                // Tap same tab = pop to root
                router.popToRoot()
            } else {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    router.selectedTab = tab
                }
            }
        } label: {
            VStack(spacing: VybeSpacing.xxxs) {
                Image(systemName: router.selectedTab == tab ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20))
                    .symbolEffect(.bounce, value: router.selectedTab == tab)

                Text(tab.rawValue)
                    .font(VybeTypography.labelSmall)
            }
            .foregroundStyle(
                router.selectedTab == tab ? VybeColors.accent : VybeColors.muted
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, VybeSpacing.xxs)
        }
        .overlay(alignment: .topTrailing) {
            // Unread badge for chat tab
            if tab == .chat {
                let unreadCount = MockData.conversations.reduce(0) { $0 + $1.unreadCount }
                if unreadCount > 0 {
                    Text("\(unreadCount)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(VybeColors.accentPink, in: Capsule())
                        .offset(x: -12, y: 2)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AppRouter())
        .environment(AuthManager.shared)
        .environment(ThemeManager.shared)
        .environment(LocationManager.shared)
}
