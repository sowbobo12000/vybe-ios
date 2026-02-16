import SwiftUI

/// A status badge component for labels, categories, and status indicators.
struct VybeBadge: View {
    enum Style {
        case filled
        case outlined
        case subtle
    }

    let text: String
    var icon: String? = nil
    var color: Color = VybeColors.accent
    var style: Style = .subtle
    var size: VybeButton.Size = .small

    var body: some View {
        HStack(spacing: VybeSpacing.xxs) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: iconSize))
            }
            Text(text)
                .font(fontSize)
                .fontWeight(.medium)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .foregroundStyle(foregroundColor)
        .background {
            Capsule()
                .fill(backgroundColor)
        }
        .overlay {
            if style == .outlined {
                Capsule()
                    .stroke(color.opacity(0.4), lineWidth: 1)
            }
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .outlined: return color
        case .subtle: return color
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .filled: return color
        case .outlined: return Color.clear
        case .subtle: return color.opacity(0.12)
        }
    }

    private var fontSize: Font {
        switch size {
        case .small: return VybeTypography.labelSmall
        case .medium: return VybeTypography.labelMedium
        case .large: return VybeTypography.labelLarge
        }
    }

    private var iconSize: CGFloat {
        switch size {
        case .small: return 10
        case .medium: return 12
        case .large: return 14
        }
    }

    private var horizontalPadding: CGFloat {
        switch size {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }

    private var verticalPadding: CGFloat {
        switch size {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        VybeBadge(text: "New", icon: "sparkles", color: VybeColors.accentCyan, style: .filled)
        VybeBadge(text: "Electronics", style: .subtle)
        VybeBadge(text: "Sold", color: VybeColors.success, style: .outlined)
        VybeBadge(text: "Urgent", color: VybeColors.danger, style: .filled)
    }
    .padding()
    .background(VybeColors.background)
}
