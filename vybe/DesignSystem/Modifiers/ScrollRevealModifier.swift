import SwiftUI

/// A ViewModifier that animates content into view with a fade + slide when it first appears
/// on screen, creating a scroll-reveal effect.
struct ScrollRevealModifier: ViewModifier {
    let delay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(
                    .spring(response: 0.6, dampingFraction: 0.8)
                    .delay(delay)
                ) {
                    isVisible = true
                }
            }
    }
}
