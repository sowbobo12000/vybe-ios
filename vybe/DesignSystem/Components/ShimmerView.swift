import SwiftUI

/// A loading skeleton shimmer view that animates a gradient sweep across its shape.
struct ShimmerView: View {
    var width: CGFloat? = nil
    var height: CGFloat = 20
    var cornerRadius: CGFloat = VybeSpacing.radiusSM

    @State private var phase: CGFloat = -1.0

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(VybeColors.surface)
            .frame(width: width, height: height)
            .overlay {
                GeometryReader { geometry in
                    let gradientWidth = geometry.size.width * 0.6
                    LinearGradient(
                        colors: [
                            Color.clear,
                            VybeColors.surfaceHover.opacity(0.6),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: gradientWidth)
                    .offset(x: phase * (geometry.size.width + gradientWidth) - gradientWidth)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            }
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1.0
                }
            }
    }
}

/// A loading skeleton for a listing card
struct ListingCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: VybeSpacing.xs) {
            ShimmerView(height: 180, cornerRadius: VybeSpacing.radiusMD)

            VStack(alignment: .leading, spacing: VybeSpacing.xxs) {
                ShimmerView(width: 80, height: 24, cornerRadius: VybeSpacing.radiusXS)
                ShimmerView(height: 16, cornerRadius: VybeSpacing.radiusXS)
                ShimmerView(width: 120, height: 14, cornerRadius: VybeSpacing.radiusXS)
            }
            .padding(.horizontal, VybeSpacing.xs)
            .padding(.bottom, VybeSpacing.xs)
        }
        .background(VybeColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: VybeSpacing.radiusLG, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 16) {
        ShimmerView(height: 40)
        ShimmerView(width: 200, height: 20)
        ListingCardSkeleton()
            .frame(width: 200)
    }
    .padding()
    .background(VybeColors.background)
}
