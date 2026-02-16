import SwiftUI

/// A glass morphism card component with optional glow and border effects.
struct VybeCard<Content: View>: View {
    var padding: CGFloat = VybeSpacing.cardPadding
    var cornerRadius: CGFloat = VybeSpacing.radiusLG
    var showGlow: Bool = false
    var glowColor: Color = VybeColors.accent
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(VybeColors.surface)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.ultraThinMaterial.opacity(0.3))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        VybeColors.borderGlow.opacity(0.5),
                                        VybeColors.border.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
            }
            .if(showGlow) { view in
                view.shadow(color: glowColor.opacity(0.15), radius: 20, x: 0, y: 8)
            }
    }
}

#Preview {
    VStack(spacing: 16) {
        VybeCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Glass Card")
                    .font(VybeTypography.heading3)
                    .foregroundStyle(VybeColors.foreground)
                Text("This card uses glass morphism effects")
                    .font(VybeTypography.bodyMedium)
                    .foregroundStyle(VybeColors.muted)
            }
        }

        VybeCard(showGlow: true) {
            Text("Glowing Card")
                .font(VybeTypography.heading3)
                .foregroundStyle(VybeColors.foreground)
        }
    }
    .padding()
    .background(VybeColors.background)
}
