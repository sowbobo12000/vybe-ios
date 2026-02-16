import SwiftUI

/// Phone OTP + Social login screen with Digital Aurora aesthetic.
struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager

    @State private var phone = ""
    @State private var otp = ""
    @State private var step: Step = .phone
    @State private var isLoading = false

    enum Step { case phone, otp }

    var body: some View {
        NavigationStack {
            ZStack {
                VybeColors.background.ignoresSafeArea()
                auroraOrbs

                ScrollView {
                    VStack(spacing: VybeSpacing.xxl) {
                        Spacer().frame(height: 40)

                        // Logo
                        Text("vybe")
                            .font(VybeTypography.displayLarge)
                            .foregroundStyle(VybeColors.primaryGradient)

                        Text("Buy & sell with your community")
                            .font(VybeTypography.bodyLarge)
                            .foregroundStyle(VybeColors.muted)

                        // Auth Card
                        VybeCard {
                            VStack(spacing: VybeSpacing.lg) {
                                if step == .phone {
                                    phoneStep
                                } else {
                                    otpStep
                                }
                            }
                        }
                        .padding(.horizontal, VybeSpacing.screenHorizontal)

                        // Social Login
                        VStack(spacing: VybeSpacing.md) {
                            dividerWithText("or continue with")

                            HStack(spacing: VybeSpacing.md) {
                                socialButton(icon: "apple.logo", label: "Apple") {
                                    Task { await socialLogin() }
                                }
                                socialButton(icon: "g.circle.fill", label: "Google") {
                                    Task { await socialLogin() }
                                }
                            }
                            .padding(.horizontal, VybeSpacing.screenHorizontal)
                        }

                        // Demo Login
                        Button("Skip — use demo account") {
                            authManager.demoLogin()
                            dismiss()
                        }
                        .font(VybeTypography.labelMedium)
                        .foregroundStyle(VybeColors.muted)

                        Spacer()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(VybeColors.muted)
                    }
                }
            }
        }
    }

    // MARK: - Phone Step

    private var phoneStep: some View {
        VStack(spacing: VybeSpacing.md) {
            Text("Enter your phone number")
                .font(VybeTypography.heading3)
                .foregroundStyle(VybeColors.foreground)

            HStack(spacing: VybeSpacing.xs) {
                Text("+1")
                    .font(VybeTypography.bodyLarge)
                    .foregroundStyle(VybeColors.foreground)
                    .padding(.horizontal, VybeSpacing.sm)
                    .padding(.vertical, VybeSpacing.sm)
                    .background(VybeColors.surfaceHover, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))

                TextField("(555) 123-4567", text: $phone)
                    .font(VybeTypography.bodyLarge)
                    .foregroundStyle(VybeColors.foreground)
                    .keyboardType(.phonePad)
                    .padding(VybeSpacing.sm)
                    .background(VybeColors.surfaceHover, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
            }

            VybeButton(
                title: "Send Code",
                icon: "arrow.right",
                variant: .primary,
                size: .large,
                isFullWidth: true,
                isLoading: isLoading,
                isDisabled: phone.count < 7
            ) {
                Task { await sendCode() }
            }
        }
    }

    // MARK: - OTP Step

    private var otpStep: some View {
        VStack(spacing: VybeSpacing.md) {
            Text("Enter verification code")
                .font(VybeTypography.heading3)
                .foregroundStyle(VybeColors.foreground)

            Text("Sent to +1 \(phone)")
                .font(VybeTypography.bodySmall)
                .foregroundStyle(VybeColors.muted)

            // OTP Input
            HStack(spacing: VybeSpacing.xs) {
                ForEach(0..<6, id: \.self) { index in
                    let char = index < otp.count ? String(otp[otp.index(otp.startIndex, offsetBy: index)]) : ""
                    Text(char)
                        .font(VybeTypography.displaySmall)
                        .foregroundStyle(VybeColors.foreground)
                        .frame(width: 44, height: 56)
                        .background(VybeColors.surfaceHover, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
                        .overlay {
                            RoundedRectangle(cornerRadius: VybeSpacing.radiusMD)
                                .stroke(index == otp.count ? VybeColors.accent : VybeColors.border, lineWidth: 1)
                        }
                }
            }
            .overlay {
                TextField("", text: $otp)
                    .keyboardType(.numberPad)
                    .opacity(0.01)
                    .onChange(of: otp) { _, newValue in
                        otp = String(newValue.prefix(6))
                        if otp.count == 6 {
                            Task { await verifyCode() }
                        }
                    }
            }

            VybeButton(
                title: "Verify",
                variant: .primary,
                size: .large,
                isFullWidth: true,
                isLoading: isLoading,
                isDisabled: otp.count < 6
            ) {
                Task { await verifyCode() }
            }

            Button("Resend code") {
                Task { await sendCode() }
            }
            .font(VybeTypography.labelMedium)
            .foregroundStyle(VybeColors.accent)

            Button("Change number") {
                withAnimation { step = .phone }
            }
            .font(VybeTypography.labelSmall)
            .foregroundStyle(VybeColors.muted)
        }
    }

    // MARK: - Social Button

    private func socialButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: VybeSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(VybeTypography.labelMedium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, VybeSpacing.sm)
            .foregroundStyle(VybeColors.foreground)
            .background(VybeColors.surface, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
            .overlay {
                RoundedRectangle(cornerRadius: VybeSpacing.radiusMD)
                    .stroke(VybeColors.border, lineWidth: 1)
            }
        }
    }

    private func dividerWithText(_ text: String) -> some View {
        HStack(spacing: VybeSpacing.sm) {
            Rectangle().fill(VybeColors.border).frame(height: 0.5)
            Text(text)
                .font(VybeTypography.caption)
                .foregroundStyle(VybeColors.muted)
                .fixedSize()
            Rectangle().fill(VybeColors.border).frame(height: 0.5)
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
    }

    // MARK: - Aurora Background

    private var auroraOrbs: some View {
        ZStack {
            Circle()
                .fill(VybeColors.accent.opacity(0.08))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: -80, y: -200)
            Circle()
                .fill(VybeColors.accentPink.opacity(0.06))
                .frame(width: 250, height: 250)
                .blur(radius: 70)
                .offset(x: 120, y: 100)
        }
    }

    // MARK: - Actions

    private func sendCode() async {
        isLoading = true
        try? await authManager.requestOTP(phone: phone)
        isLoading = false
        withAnimation { step = .otp }
    }

    private func verifyCode() async {
        isLoading = true
        try? await authManager.verifyOTP(phone: phone, code: otp)
        isLoading = false
        dismiss()
    }

    private func socialLogin() async {
        isLoading = true
        try? await authManager.signInWithApple(identityToken: Data())
        isLoading = false
        dismiss()
    }
}

#Preview {
    LoginView()
        .environment(AuthManager.shared)
}
