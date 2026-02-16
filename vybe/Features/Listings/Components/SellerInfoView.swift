import SwiftUI

/// Seller info row with avatar, manner temperature, and action buttons.
struct SellerInfoView: View {
    let name: String
    let avatarURL: String?
    let location: String?
    let mannerTemp: Double
    var onMessageTap: (() -> Void)? = nil
    var onProfileTap: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: VybeSpacing.sm) {
            HStack(spacing: VybeSpacing.sm) {
                // Avatar
                Button {
                    onProfileTap?()
                } label: {
                    VybeAvatar(name: name, imageURL: avatarURL, size: .medium)
                }

                // Info
                VStack(alignment: .leading, spacing: VybeSpacing.xxxs) {
                    Button {
                        onProfileTap?()
                    } label: {
                        Text(name)
                            .font(VybeTypography.heading4)
                            .foregroundStyle(VybeColors.foreground)
                    }

                    if let location {
                        HStack(spacing: VybeSpacing.xxs) {
                            Image(systemName: "mappin")
                                .font(.system(size: 10))
                            Text(location)
                        }
                        .font(VybeTypography.caption)
                        .foregroundStyle(VybeColors.muted)
                    }
                }

                Spacer()

                // Manner Temperature
                VStack(spacing: VybeSpacing.xxxs) {
                    HStack(spacing: 3) {
                        Image(systemName: "thermometer.medium")
                            .font(.system(size: 13))
                        Text(Formatters.formatMannerTemp(mannerTemp))
                            .font(VybeTypography.labelMedium)
                    }
                    .foregroundStyle(VybeColors.mannerTempColor(for: mannerTemp))

                    Text("manner")
                        .font(.system(size: 9))
                        .foregroundStyle(VybeColors.muted)
                }
                .padding(.horizontal, VybeSpacing.sm)
                .padding(.vertical, VybeSpacing.xxs)
                .background(
                    VybeColors.mannerTempColor(for: mannerTemp).opacity(0.1),
                    in: RoundedRectangle(cornerRadius: VybeSpacing.radiusSM)
                )
            }

            // Message Button
            if onMessageTap != nil {
                VybeButton(
                    title: "Message Seller",
                    icon: "bubble.left.fill",
                    variant: .secondary,
                    isFullWidth: true
                ) {
                    onMessageTap?()
                }
            }
        }
    }
}

#Preview {
    VStack {
        SellerInfoView(
            name: "Sarah Chen",
            avatarURL: nil,
            location: "Berkeley, CA",
            mannerTemp: 42.1,
            onMessageTap: {},
            onProfileTap: {}
        )
    }
    .padding()
    .background(VybeColors.background)
}
