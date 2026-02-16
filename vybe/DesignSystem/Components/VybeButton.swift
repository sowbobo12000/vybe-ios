import SwiftUI

/// A styled button component for the vybe design system.
/// Supports primary (gradient), secondary (outlined), and ghost variants.
struct VybeButton: View {
    enum Variant {
        case primary
        case secondary
        case ghost
        case danger
    }

    enum Size {
        case small
        case medium
        case large

        var verticalPadding: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 24
            case .large: return 32
            }
        }

        var font: Font {
            switch self {
            case .small: return VybeTypography.labelSmall
            case .medium: return VybeTypography.labelMedium
            case .large: return VybeTypography.labelLarge
            }
        }
    }

    let title: String
    var icon: String? = nil
    var variant: Variant = .primary
    var size: Size = .medium
    var isFullWidth: Bool = false
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: VybeSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(size.font)
                    }
                    Text(title)
                        .font(size.font)
                        .fontWeight(.semibold)
                }
            }
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .foregroundStyle(foregroundColor)
            .background {
                backgroundView
            }
            .clipShape(RoundedRectangle(cornerRadius: VybeSpacing.radiusMD, style: .continuous))
            .overlay {
                if variant == .secondary {
                    RoundedRectangle(cornerRadius: VybeSpacing.radiusMD, style: .continuous)
                        .stroke(VybeColors.border, lineWidth: 1)
                }
            }
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
        .cardHoverEffect()
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch variant {
        case .primary:
            VybeColors.primaryGradient
                .glowShadow(color: VybeColors.accent, radius: 16, opacity: 0.4)
        case .secondary:
            VybeColors.surface
        case .ghost:
            Color.clear
        case .danger:
            VybeColors.danger.opacity(0.15)
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary:
            return .white
        case .secondary:
            return VybeColors.foreground
        case .ghost:
            return VybeColors.muted
        case .danger:
            return VybeColors.danger
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        VybeButton(title: "Make Offer", icon: "hand.raised.fill", variant: .primary, size: .large, isFullWidth: true) {}
        VybeButton(title: "Message Seller", icon: "bubble.left.fill", variant: .secondary, isFullWidth: true) {}
        VybeButton(title: "Cancel", variant: .ghost) {}
        VybeButton(title: "Delete Listing", icon: "trash", variant: .danger) {}
        VybeButton(title: "Loading...", variant: .primary, isLoading: true) {}
    }
    .padding()
    .background(VybeColors.background)
}
