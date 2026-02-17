import SwiftUI

/// About the app screen.
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: VybeSpacing.xl) {
                // Logo
                VStack(spacing: VybeSpacing.sm) {
                    Text("vybe")
                        .font(VybeTypography.displaySmall)
                        .foregroundStyle(VybeColors.primaryGradient)

                    Text("Version 1.0.0")
                        .font(VybeTypography.bodySmall)
                        .foregroundStyle(VybeColors.muted)
                }
                .padding(.top, VybeSpacing.xxxl)

                // Description
                VStack(spacing: VybeSpacing.md) {
                    Text("The next-gen marketplace for Gen-Z")
                        .font(VybeTypography.heading3)
                        .foregroundStyle(VybeColors.foreground)
                        .multilineTextAlignment(.center)

                    Text("Buy, sell, and connect with your local community. vybe makes it easy to find great deals and meet amazing people nearby.")
                        .font(VybeTypography.bodyMedium)
                        .foregroundStyle(VybeColors.muted)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, VybeSpacing.xl)

                Spacer()
            }
        }
        .background(VybeColors.background)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
