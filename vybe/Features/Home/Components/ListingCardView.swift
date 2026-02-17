import SwiftUI

/// A marketplace listing card with image, price, title, location, and seller info.
/// Designed to match the "Digital Aurora" aesthetic with glass morphism and subtle glow.
struct ListingCardView: View {
    let listing: ListingSummary
    var onLikeTap: (() -> Void)? = nil

    @State private var imageLoaded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
            ZStack(alignment: .topTrailing) {
                imageView
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipped()

                // Like Button
                Button {
                    onLikeTap?()
                } label: {
                    Image(systemName: listing.isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(listing.isLiked ? VybeColors.accentPink : .white)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding(VybeSpacing.xs)

                // Featured badge
                if listing.isFeatured {
                    VybeBadge(
                        text: "Featured",
                        icon: "sparkles",
                        color: VybeColors.accentCyan,
                        style: .filled
                    )
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(VybeSpacing.xs)
                }
            }

            // Info Section
            VStack(alignment: .leading, spacing: VybeSpacing.xxs) {
                // Price Row
                HStack(alignment: .firstTextBaseline, spacing: VybeSpacing.xs) {
                    Text(Formatters.formatPrice(listing.price))
                        .font(VybeTypography.priceMedium)
                        .foregroundStyle(VybeColors.foreground)

                    if let originalPrice = listing.originalPrice, originalPrice > listing.price {
                        Text(Formatters.formatPrice(originalPrice))
                            .font(VybeTypography.caption)
                            .strikethrough()
                            .foregroundStyle(VybeColors.muted)

                        let discount = Int(Double(originalPrice - listing.price) / Double(originalPrice) * 100)
                        Text("-\(discount)%")
                            .font(VybeTypography.captionBold)
                            .foregroundStyle(VybeColors.success)
                    }
                }

                // Title
                Text(listing.title)
                    .font(VybeTypography.bodyMedium)
                    .foregroundStyle(VybeColors.foreground)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                // Location + Time
                HStack(spacing: VybeSpacing.xxs) {
                    if let distance = listing.distanceText {
                        Image(systemName: "location.fill")
                            .font(.system(size: 9))
                        Text(distance)
                            .font(VybeTypography.caption)
                    }

                    if listing.distanceText != nil {
                        Text("·")
                            .font(VybeTypography.caption)
                    }

                    Text(listing.createdAt.timeAgo)
                        .font(VybeTypography.caption)
                }
                .foregroundStyle(VybeColors.muted)

                // Seller Row
                HStack(spacing: VybeSpacing.xxs) {
                    VybeAvatar(
                        name: listing.sellerName,
                        imageURL: listing.sellerAvatarURL,
                        size: .small
                    )

                    Text(listing.sellerName)
                        .font(VybeTypography.caption)
                        .foregroundStyle(VybeColors.muted)
                        .lineLimit(1)

                    Spacer()

                    // Manner Temperature Badge
                    HStack(spacing: 2) {
                        Image(systemName: "thermometer.medium")
                            .font(.system(size: 9))
                        Text(Formatters.formatMannerTemp(listing.sellerMannerTemp))
                            .font(VybeTypography.labelSmall)
                    }
                    .foregroundStyle(VybeColors.mannerTempColor(for: listing.sellerMannerTemp))
                }
            }
            .padding(.horizontal, VybeSpacing.sm)
            .padding(.vertical, VybeSpacing.sm)
        }
        .background(VybeColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: VybeSpacing.radiusLG, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: VybeSpacing.radiusLG, style: .continuous)
                .stroke(VybeColors.border.opacity(0.5), lineWidth: 0.5)
        }
        .cardHoverEffect()
    }

    // MARK: - Image View

    @ViewBuilder
    private var imageView: some View {
        if let thumbnailURL = listing.thumbnailURL, let url = URL(string: thumbnailURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .opacity(imageLoaded ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.3)) {
                                imageLoaded = true
                            }
                        }
                case .failure:
                    imagePlaceholder
                case .empty:
                    ShimmerView(height: 180, cornerRadius: 0)
                @unknown default:
                    imagePlaceholder
                }
            }
        } else {
            imagePlaceholder
        }
    }

    private var imagePlaceholder: some View {
        ZStack {
            VybeColors.surfaceHover
            Image(systemName: "photo")
                .font(.system(size: 32))
                .foregroundStyle(VybeColors.muted.opacity(0.5))
        }
    }
}

#Preview {
    LazyVGrid(
        columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ],
        spacing: 12
    ) {
        ForEach(MockData.listings.prefix(4)) { listing in
            ListingCardView(listing: listing)
        }
    }
    .padding()
    .background(VybeColors.background)
}
