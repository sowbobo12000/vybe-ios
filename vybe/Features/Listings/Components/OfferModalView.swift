import SwiftUI

/// Bottom sheet modal for making price offers with quick-select percentages.
struct OfferModalView: View {
    @Bindable var viewModel: ListingDetailViewModel

    private var listing: ListingSummary? { viewModel.listing }

    private var quickOffers: [(label: String, amount: Int)] {
        guard let listing else { return [] }
        return [
            ("-5%", Int(Double(listing.price) * 0.95)),
            ("-10%", Int(Double(listing.price) * 0.90)),
            ("-15%", Int(Double(listing.price) * 0.85)),
        ]
    }

    var body: some View {
        VStack(spacing: VybeSpacing.lg) {
            // Drag indicator is handled by presentationDragIndicator

            // Listing Summary
            if let listing {
                HStack(spacing: VybeSpacing.sm) {
                    if let url = listing.thumbnailURL, let imageURL = URL(string: url) {
                        AsyncImage(url: imageURL) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            VybeColors.surfaceHover
                        }
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: VybeSpacing.radiusSM))
                    }

                    VStack(alignment: .leading, spacing: VybeSpacing.xxxs) {
                        Text(listing.title)
                            .font(VybeTypography.labelMedium)
                            .foregroundStyle(VybeColors.foreground)
                            .lineLimit(1)
                        Text("Listed at \(Formatters.formatPrice(listing.price))")
                            .font(VybeTypography.bodySmall)
                            .foregroundStyle(VybeColors.muted)
                    }

                    Spacer()
                }
            }

            // Quick Offer Buttons
            HStack(spacing: VybeSpacing.xs) {
                ForEach(quickOffers, id: \.amount) { offer in
                    Button {
                        viewModel.offerAmount = "\(offer.amount)"
                    } label: {
                        VStack(spacing: VybeSpacing.xxxs) {
                            Text(offer.label)
                                .font(VybeTypography.labelSmall)
                                .foregroundStyle(VybeColors.accent)
                            Text(Formatters.formatPrice(offer.amount))
                                .font(VybeTypography.caption)
                                .foregroundStyle(VybeColors.muted)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, VybeSpacing.xs)
                        .background(VybeColors.surface, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
                        .overlay {
                            RoundedRectangle(cornerRadius: VybeSpacing.radiusMD)
                                .stroke(
                                    viewModel.offerAmount == "\(offer.amount)" ? VybeColors.accent : VybeColors.border,
                                    lineWidth: 1
                                )
                        }
                    }
                }
            }

            // Custom Amount
            VStack(alignment: .leading, spacing: VybeSpacing.xxs) {
                Text("Your offer")
                    .font(VybeTypography.labelSmall)
                    .foregroundStyle(VybeColors.muted)

                HStack(spacing: VybeSpacing.xs) {
                    Text("$")
                        .font(VybeTypography.heading2)
                        .foregroundStyle(VybeColors.foreground)

                    TextField("0", text: $viewModel.offerAmount)
                        .font(VybeTypography.heading2)
                        .foregroundStyle(VybeColors.foreground)
                        .keyboardType(.numberPad)
                }
                .padding(VybeSpacing.sm)
                .background(VybeColors.surfaceHover, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
            }

            // Optional Message
            TextField("Add a message (optional)", text: $viewModel.offerMessage)
                .font(VybeTypography.bodyMedium)
                .foregroundStyle(VybeColors.foreground)
                .padding(VybeSpacing.sm)
                .background(VybeColors.surfaceHover, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))

            // Submit
            VybeButton(
                title: "Send Offer",
                icon: "hand.raised.fill",
                variant: .primary,
                size: .large,
                isFullWidth: true,
                isLoading: viewModel.isSubmittingOffer,
                isDisabled: viewModel.offerAmount.isEmpty
            ) {
                Task { await viewModel.submitOffer() }
            }
        }
        .padding(VybeSpacing.screenHorizontal)
        .padding(.top, VybeSpacing.sm)
        .background(VybeColors.background)
    }
}

#Preview {
    OfferModalView(viewModel: ListingDetailViewModel(listingID: "listing-1"))
        .presentationDetents([.medium])
}
