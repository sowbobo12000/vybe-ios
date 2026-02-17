import SwiftUI

/// User profile screen with listings, reviews, and account stats.
struct ProfileView: View {
    var userID: String? = nil

    @Environment(AppRouter.self) private var router
    @Environment(AuthManager.self) private var authManager
    @State private var selectedTab: ProfileTab = .listings
    @State private var user: UserSummary?

    private var isOwnProfile: Bool {
        userID == nil || userID == "current-user-id"
    }

    enum ProfileTab: String, CaseIterable {
        case listings = "Listings"
        case offers = "Offers"
        case reviews = "Reviews"
    }

    private let columns = [
        GridItem(.flexible(), spacing: VybeSpacing.gridSpacing),
        GridItem(.flexible(), spacing: VybeSpacing.gridSpacing)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: VybeSpacing.lg) {
                // Header
                profileHeader

                // Stats
                statsRow

                // Tab Picker
                tabPicker

                // Tab Content
                tabContent
            }
            .padding(.bottom, 100)
        }
        .background(VybeColors.background)
        .navigationTitle(isOwnProfile ? "Profile" : (user?.displayName ?? ""))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isOwnProfile {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        router.navigate(to: .settings)
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 16))
                            .foregroundStyle(VybeColors.foreground)
                    }
                }
            }
        }
        .onAppear { loadUser() }
    }

    // MARK: - Header

    private var profileHeader: some View {
        VStack(spacing: VybeSpacing.md) {
            VybeAvatar(
                name: user?.displayName ?? "User",
                imageURL: user?.avatarURL,
                size: .large
            )

            VStack(spacing: VybeSpacing.xxxs) {
                HStack(spacing: VybeSpacing.xxs) {
                    Text(user?.displayName ?? "User")
                        .font(VybeTypography.heading2)
                        .foregroundStyle(VybeColors.foreground)

                    if user?.isVerified == true {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(VybeColors.accentCyan)
                    }
                }

                Text("@\(user?.username ?? "username")")
                    .font(VybeTypography.bodySmall)
                    .foregroundStyle(VybeColors.muted)

                if let location = user?.location {
                    HStack(spacing: VybeSpacing.xxs) {
                        Image(systemName: "mappin")
                            .font(.system(size: 11))
                        Text(location)
                    }
                    .font(VybeTypography.caption)
                    .foregroundStyle(VybeColors.muted)
                }
            }

            // Manner Temperature
            if let temp = user?.mannerTemperature {
                HStack(spacing: VybeSpacing.xxs) {
                    Image(systemName: "thermometer.medium")
                        .font(.system(size: 14))
                    Text(Formatters.formatMannerTemp(temp))
                        .font(VybeTypography.labelMedium)
                }
                .foregroundStyle(VybeColors.mannerTempColor(for: temp))
                .padding(.horizontal, VybeSpacing.md)
                .padding(.vertical, VybeSpacing.xxs)
                .background(VybeColors.mannerTempColor(for: temp).opacity(0.12), in: Capsule())
            }

            // Action Buttons
            if !isOwnProfile {
                HStack(spacing: VybeSpacing.sm) {
                    VybeButton(title: "Message", icon: "bubble.left.fill", variant: .primary, isFullWidth: true) {
                        if let id = userID {
                            router.navigate(to: .newChat(userID: id, listingID: nil))
                        }
                    }
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)
            } else {
                VybeButton(title: "Edit Profile", icon: "pencil", variant: .secondary) {
                    router.navigate(to: .editProfile)
                }
            }
        }
        .padding(.top, VybeSpacing.lg)
    }

    // MARK: - Stats

    private var statsRow: some View {
        VybeCard {
            HStack(spacing: 0) {
                statItem(value: "12", label: "Listings")
                Spacer()
                statItem(value: "8", label: "Sales")
                Spacer()
                statItem(value: "24", label: "Reviews")
                Spacer()
                statItem(value: "4.9", label: "Rating")
            }
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: VybeSpacing.xxxs) {
            Text(value)
                .font(VybeTypography.heading3)
                .foregroundStyle(VybeColors.foreground)
            Text(label)
                .font(VybeTypography.caption)
                .foregroundStyle(VybeColors.muted)
        }
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(ProfileTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3)) { selectedTab = tab }
                } label: {
                    VStack(spacing: VybeSpacing.xs) {
                        Text(tab.rawValue)
                            .font(VybeTypography.labelMedium)
                            .foregroundStyle(selectedTab == tab ? VybeColors.foreground : VybeColors.muted)

                        Rectangle()
                            .fill(selectedTab == tab ? VybeColors.accent : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .listings:
            let userListings = isOwnProfile ? MockData.listings : MockData.listings.filter { $0.sellerID == userID }
            if userListings.isEmpty {
                emptyState(icon: "tag", message: "No listings yet")
            } else {
                LazyVGrid(columns: columns, spacing: VybeSpacing.gridSpacing) {
                    ForEach(userListings) { listing in
                        ListingCardView(listing: listing)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                router.navigate(to: .listingDetail(id: listing.id))
                            }
                    }
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)
            }

        case .offers:
            LazyVStack(spacing: VybeSpacing.sm) {
                ForEach(MockData.offers) { offer in
                    offerRow(offer)
                }
            }
            .padding(.horizontal, VybeSpacing.screenHorizontal)

        case .reviews:
            emptyState(icon: "star", message: "No reviews yet")
        }
    }

    // MARK: - Offer Row

    private func offerRow(_ offer: Offer) -> some View {
        VybeCard {
            HStack(spacing: VybeSpacing.sm) {
                VStack(alignment: .leading, spacing: VybeSpacing.xxxs) {
                    Text(offer.listingTitle)
                        .font(VybeTypography.labelMedium)
                        .foregroundStyle(VybeColors.foreground)
                        .lineLimit(1)

                    HStack(spacing: VybeSpacing.xs) {
                        Text(Formatters.formatPrice(offer.amount))
                            .font(VybeTypography.priceMedium)
                            .foregroundStyle(VybeColors.foreground)

                        Text("of \(Formatters.formatPrice(offer.listingPrice))")
                            .font(VybeTypography.caption)
                            .foregroundStyle(VybeColors.muted)
                    }
                }

                Spacer()

                VybeBadge(
                    text: offer.status.rawValue.capitalized,
                    color: statusColor(offer.status),
                    style: .filled
                )
            }
        }
    }

    private func statusColor(_ status: OfferStatus) -> Color {
        switch status {
        case .pending: return VybeColors.warning
        case .accepted: return VybeColors.success
        case .declined: return VybeColors.danger
        case .countered: return VybeColors.accentCyan
        case .withdrawn: return VybeColors.muted
        case .expired: return VybeColors.muted
        }
    }

    private func emptyState(icon: String, message: String) -> some View {
        VStack(spacing: VybeSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(VybeColors.muted)
            Text(message)
                .font(VybeTypography.bodyMedium)
                .foregroundStyle(VybeColors.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, VybeSpacing.xxl)
    }

    private func loadUser() {
        if let userID, userID != "current-user-id" {
            user = MockData.users.first { $0.id == userID }
        } else {
            user = MockData.currentUser
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environment(AppRouter())
    .environment(AuthManager.shared)
}
