import SwiftUI

extension View {
    /// Apply a glass morphism card style
    func vybeCard(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(GlassMorphismModifier(cornerRadius: cornerRadius))
    }

    /// Apply the aurora background effect
    func auroraBackground() -> some View {
        self.modifier(AuroraBackground())
    }

    /// Apply a press/tap hover feedback effect
    func cardHoverEffect() -> some View {
        self.modifier(CardHoverEffect())
    }

    /// Apply scroll reveal animation
    func scrollReveal(delay: Double = 0) -> some View {
        self.modifier(ScrollRevealModifier(delay: delay))
    }

    /// Conditionally apply a modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Apply a glow shadow with a given color
    func glowShadow(color: Color = VybeColors.accent, radius: CGFloat = 20, opacity: Double = 0.3) -> some View {
        self.shadow(color: color.opacity(opacity), radius: radius, x: 0, y: 4)
    }

    /// Hide the view based on a condition
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide {
            self.hidden()
        } else {
            self
        }
    }
}
