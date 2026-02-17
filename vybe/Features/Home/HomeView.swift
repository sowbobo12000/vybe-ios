import SwiftUI

/// The main home feed view with hero banner, category pills, and listing grid.
struct HomeView: View {
    @Environment(AppRouter.self) private var router
    @Environment(LocationManager.self) private var locationManager
    @State private var viewModel = HomeViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: VybeSpacing.gridSpacing),
        GridItem(.flexible(), spacing: VybeSpacing.gridSpacing)
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: VybeSpacing.sectionSpacing) {
                // Hero Banner
                HeroBannerView(listings: viewModel.featuredListings)
                    .scrollReveal()

                // Category Bar
                CategoryBarView(
                    selectedCategory: viewModel.selectedCategory,
                    onSelect: { viewModel.selectCategory($0) }
                )
                .scrollReveal(delay: 0.1)

                // Section Header
                sectionHeader(title: "Nearby Listings", subtitle: locationManager.locationName)
                    .scrollReveal(delay: 0.15)

                // Listing Grid
                if viewModel.isLoading && viewModel.listings.isEmpty {
                    loadingGrid
                } else if viewModel.listings.isEmpty {
                    emptyState
                } else {
                    listingGrid
                }
            }
            .padding(.bottom, 100) // Space for tab bar
        }
        .refreshable {
            await viewModel.refresh()
        }
        .background(VybeColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: VybeSpacing.xs) {
                    Text("vybe")
                        .font(VybeTypography.displaySmall)
                        .foregroundStyle(VybeColors.primaryGradient)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: VybeSpacing.sm) {
                    Button {
                        router.showCreateListing = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(VybeColors.accent)
                    }

                    Button {
                        // Notifications
                    } label: {
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                            .foregroundStyle(VybeColors.foreground)
                    }
                }
            }
        }
        .toolbarBackground(VybeColors.background, for: .navigationBar)
    }

    // MARK: - Listing Grid

    private var listingGrid: some View {
        LazyVGrid(columns: columns, spacing: VybeSpacing.gridSpacing) {
            ForEach(Array(viewModel.listings.enumerated()), id: \.element.id) { index, listing in
                ListingCardView(listing: listing) {
                    viewModel.toggleLike(for: listing.id)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    router.navigate(to: .listingDetail(id: listing.id))
                }
                .scrollReveal(delay: Double(index) * 0.05)
            }
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
    }

    // MARK: - Loading State

    private var loadingGrid: some View {
        LazyVGrid(columns: columns, spacing: VybeSpacing.gridSpacing) {
            ForEach(0..<6, id: \.self) { _ in
                ListingCardSkeleton()
            }
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: VybeSpacing.md) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(VybeColors.muted)

            Text("No listings found")
                .font(VybeTypography.heading3)
                .foregroundStyle(VybeColors.foreground)

            Text("Try a different category or check back later")
                .font(VybeTypography.bodyMedium)
                .foregroundStyle(VybeColors.muted)
                .multilineTextAlignment(.center)

            VybeButton(title: "Clear Filter", variant: .secondary) {
                viewModel.selectCategory(nil)
            }
        }
        .padding(VybeSpacing.xxl)
    }

    // MARK: - Section Header

    private func sectionHeader(title: String, subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: VybeSpacing.xxxs) {
                Text(title)
                    .font(VybeTypography.heading2)
                    .foregroundStyle(VybeColors.foreground)

                HStack(spacing: VybeSpacing.xxs) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11))
                    Text(subtitle)
                        .font(VybeTypography.bodySmall)
                }
                .foregroundStyle(VybeColors.muted)
            }

            Spacer()

            Button("See All") {
                router.navigateToTab(.search)
            }
            .font(VybeTypography.labelMedium)
            .foregroundStyle(VybeColors.accent)
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppRouter())
    .environment(LocationManager.shared)
}
