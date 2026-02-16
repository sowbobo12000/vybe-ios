import SwiftUI

/// An auto-scrolling hero banner showcasing featured listings with a gradient overlay.
struct HeroBannerView: View {
    let listings: [ListingSummary]
    @State private var currentIndex = 0
    @State private var timer: Timer?

    var body: some View {
        if listings.isEmpty { return AnyView(EmptyView()) }

        return AnyView(
            TabView(selection: $currentIndex) {
                ForEach(Array(listings.enumerated()), id: \.element.id) { index, listing in
                    bannerCard(listing)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: VybeSpacing.radiusXL, style: .continuous))
            .padding(.horizontal, VybeSpacing.screenHorizontal)
            .onAppear { startAutoScroll() }
            .onDisappear { stopAutoScroll() }
        )
    }

    private func bannerCard(_ listing: ListingSummary) -> some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            AsyncImage(url: URL(string: listing.thumbnailURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    gradientPlaceholder
                case .empty:
                    gradientPlaceholder
                        .overlay { ProgressView().tint(.white) }
                @unknown default:
                    gradientPlaceholder
                }
            }
            .frame(height: 220)
            .clipped()

            // Gradient Overlay
            LinearGradient(
                colors: [
                    Color.black.opacity(0.7),
                    Color.black.opacity(0.3),
                    Color.clear
                ],
                startPoint: .bottom,
                endPoint: .top
            )

            // Content
            VStack(alignment: .leading, spacing: VybeSpacing.xs) {
                VybeBadge(
                    text: "Featured",
                    icon: "sparkles",
                    color: VybeColors.accentCyan,
                    style: .filled
                )

                Text(listing.title)
                    .font(VybeTypography.heading2)
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack(spacing: VybeSpacing.sm) {
                    Text(Formatters.formatPrice(listing.price))
                        .font(VybeTypography.priceLarge)
                        .foregroundStyle(.white)

                    if let distance = listing.distanceText {
                        HStack(spacing: VybeSpacing.xxxs) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 10))
                            Text(distance)
                                .font(VybeTypography.caption)
                        }
                        .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
            .padding(VybeSpacing.lg)
        }
    }

    private var gradientPlaceholder: some View {
        LinearGradient(
            colors: [
                VybeColors.accent.opacity(0.4),
                VybeColors.accentPink.opacity(0.3),
                VybeColors.surface
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Auto Scroll

    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [self] _ in
            Task { @MainActor in
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentIndex = (currentIndex + 1) % max(listings.count, 1)
                }
            }
        }
    }

    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    HeroBannerView(listings: MockData.featuredListings)
        .background(VybeColors.background)
}
