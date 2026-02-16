import SwiftUI

/// A ViewModifier that renders an animated aurora gradient background
/// with multiple slowly-moving radial gradients in pastel colors.
struct AuroraBackground: ViewModifier {
    @State private var animateGradient = false

    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    VybeColors.background
                        .ignoresSafeArea()

                    // Lavender blob — top left
                    RadialGradient(
                        colors: [
                            VybeColors.accent.opacity(0.25),
                            Color.clear
                        ],
                        center: animateGradient ? .topLeading : UnitPoint(x: 0.3, y: 0.1),
                        startRadius: 100,
                        endRadius: 400
                    )
                    .ignoresSafeArea()

                    // Cyan blob — center right
                    RadialGradient(
                        colors: [
                            VybeColors.accentCyan.opacity(0.15),
                            Color.clear
                        ],
                        center: animateGradient ? UnitPoint(x: 0.8, y: 0.4) : UnitPoint(x: 0.6, y: 0.6),
                        startRadius: 80,
                        endRadius: 350
                    )
                    .ignoresSafeArea()

                    // Pink blob — bottom
                    RadialGradient(
                        colors: [
                            VybeColors.accentPink.opacity(0.2),
                            Color.clear
                        ],
                        center: animateGradient ? UnitPoint(x: 0.4, y: 0.9) : UnitPoint(x: 0.6, y: 0.8),
                        startRadius: 60,
                        endRadius: 300
                    )
                    .ignoresSafeArea()
                }
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 8)
                        .repeatForever(autoreverses: true)
                    ) {
                        animateGradient.toggle()
                    }
                }
            }
    }
}
