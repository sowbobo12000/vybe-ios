import SwiftUI

/// Detailed view of a marketplace listing with image carousel, seller info, and offer button.
struct ListingDetailView: View {
    let listingID: String

    @Environment(AppRouter.self) private var router
    @State private var viewModel: ListingDetailViewModel

    init(listingID: String) {
        self.listingID = listingID
        _viewModel = State(initialValue: ListingDetailViewModel(listingID: listingID))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if let listing = viewModel.listing {
                listingContent(listing)
            } else {
                errorView
            }
        }
        .background(VybeColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: VybeSpacing.sm) {
                    Button { viewModel.shareListing() } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16))
                    }

                    Menu {
                        Button("Report Listing", systemImage: "flag") {
                            viewModel.reportListing()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16))
                    }
                }
                .foregroundStyle(VybeColors.foreground)
            }
        }
        .sheet(isPresented: $viewModel.showOfferModal) {
            OfferModalView(viewModel: viewModel)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Main Content

    private func listingContent(_ listing: ListingSummary) -> some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Image Carousel
                    ImageCarouselView(imageURLs: listing.imageURLs)

                    VStack(alignment: .leading, spacing: VybeSpacing.lg) {
                        // Header: Price, Title, Badges
                        listingHeader(listing)

                        Divider()
                            .background(VybeColors.border)

                        // Seller Info
                        SellerInfoView(
                            name: listing.sellerName,
                            avatarURL: listing.sellerAvatarURL,
                            location: listing.sellerLocation,
                            mannerTemp: listing.sellerMannerTemp,
                            onMessageTap: {
                                router.navigate(to: .newChat(userID: listing.sellerID, listingID: listing.id))
                            },
                            onProfileTap: {
                                router.navigate(to: .profile(userID: listing.sellerID))
                            }
                        )

                        Divider()
                            .background(VybeColors.border)

                        // Description
                        descriptionSection(listing)

                        // Stats
                        statsSection(listing)
                    }
                    .padding(.horizontal, VybeSpacing.screenHorizontal)
                    .padding(.top, VybeSpacing.lg)
                    .padding(.bottom, 120) // Space for bottom bar
                }
            }

            // Bottom Action Bar
            bottomBar(listing)
        }
    }

    // MARK: - Listing Header

    private func listingHeader(_ listing: ListingSummary) -> some View {
        VStack(alignment: .leading, spacing: VybeSpacing.sm) {
            // Badges
            HStack(spacing: VybeSpacing.xs) {
                VybeBadge(text: listing.condition, color: VybeColors.accentCyan)
                VybeBadge(text: listing.category)
                if listing.isFeatured {
                    VybeBadge(text: "Featured", icon: "sparkles", color: VybeColors.warning, style: .filled)
                }
            }

            // Title
            Text(listing.title)
                .font(VybeTypography.heading1)
                .foregroundStyle(VybeColors.foreground)
                .fixedSize(horizontal: false, vertical: true)

            // Price
            HStack(alignment: .firstTextBaseline, spacing: VybeSpacing.sm) {
                Text(Formatters.formatPrice(listing.price))
                    .font(VybeTypography.priceHero)
                    .foregroundStyle(VybeColors.foreground)

                if let originalPrice = listing.originalPrice, originalPrice > listing.price {
                    Text(Formatters.formatPrice(originalPrice))
                        .font(VybeTypography.bodyLarge)
                        .strikethrough()
                        .foregroundStyle(VybeColors.muted)

                    let discount = Int(Double(originalPrice - listing.price) / Double(originalPrice) * 100)
                    VybeBadge(text: "-\(discount)%", color: VybeColors.success, style: .filled)
                }
            }

            // Location + Time
            HStack(spacing: VybeSpacing.md) {
                if let location = listing.location {
                    HStack(spacing: VybeSpacing.xxs) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 14))
                        Text(location)
                            .font(VybeTypography.bodySmall)
                    }
                    .foregroundStyle(VybeColors.muted)
                }

                HStack(spacing: VybeSpacing.xxs) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text(listing.createdAt.timeAgo)
                        .font(VybeTypography.bodySmall)
                }
                .foregroundStyle(VybeColors.muted)
            }
        }
    }

    // MARK: - Description

    private func descriptionSection(_ listing: ListingSummary) -> some View {
        VStack(alignment: .leading, spacing: VybeSpacing.sm) {
            Text("Description")
                .font(VybeTypography.heading3)
                .foregroundStyle(VybeColors.foreground)

            Text(listing.itemDescription)
                .font(VybeTypography.bodyMedium)
                .foregroundStyle(VybeColors.foreground.opacity(0.85))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Stats

    private func statsSection(_ listing: ListingSummary) -> some View {
        VybeCard {
            HStack(spacing: 0) {
                statItem(icon: "eye", value: "\(listing.viewCount)", label: "Views")
                Spacer()
                statItem(icon: "heart", value: "\(listing.likeCount)", label: "Likes")
                Spacer()
                statItem(icon: "hand.raised", value: "\(listing.offerCount)", label: "Offers")
            }
        }
    }

    private func statItem(icon: String, value: String, label: String) -> some View {
        VStack(spacing: VybeSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(VybeColors.accent)
            Text(value)
                .font(VybeTypography.heading4)
                .foregroundStyle(VybeColors.foreground)
            Text(label)
                .font(VybeTypography.caption)
                .foregroundStyle(VybeColors.muted)
        }
    }

    // MARK: - Bottom Bar

    private func bottomBar(_ listing: ListingSummary) -> some View {
        HStack(spacing: VybeSpacing.sm) {
            // Like button
            Button { viewModel.toggleLike() } label: {
                Image(systemName: listing.isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 22))
                    .foregroundStyle(listing.isLiked ? VybeColors.accentPink : VybeColors.foreground)
                    .frame(width: 48, height: 48)
                    .background(VybeColors.surface, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
                    .overlay {
                        RoundedRectangle(cornerRadius: VybeSpacing.radiusMD)
                            .stroke(VybeColors.border, lineWidth: 1)
                    }
            }

            // Make Offer button
            VybeButton(
                title: "Make Offer",
                icon: "hand.raised.fill",
                variant: .primary,
                size: .large,
                isFullWidth: true
            ) {
                viewModel.showOfferModal = true
            }
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
        .padding(.vertical, VybeSpacing.sm)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay { Rectangle().fill(VybeColors.surface.opacity(0.7)) }
                .overlay(alignment: .top) {
                    Rectangle().fill(VybeColors.border.opacity(0.3)).frame(height: 0.5)
                }
                .ignoresSafeArea()
        }
    }

    // MARK: - Loading / Error

    private var loadingView: some View {
        VStack(spacing: VybeSpacing.md) {
            ShimmerView(height: 300)
            VStack(alignment: .leading, spacing: VybeSpacing.sm) {
                ShimmerView(width: 100, height: 32)
                ShimmerView(height: 24)
                ShimmerView(width: 200, height: 18)
            }
            .padding()
        }
    }

    private var errorView: some View {
        VStack(spacing: VybeSpacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(VybeColors.warning)
            Text(viewModel.error ?? "Something went wrong")
                .font(VybeTypography.heading3)
                .foregroundStyle(VybeColors.foreground)
            VybeButton(title: "Try Again", variant: .secondary) {
                Task { await viewModel.loadListing() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        ListingDetailView(listingID: "listing-1")
    }
    .environment(AppRouter())
}
