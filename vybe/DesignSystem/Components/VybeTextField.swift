import SwiftUI

/// A styled text input field for the vybe design system.
struct VybeTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var errorMessage: String? = nil

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: VybeSpacing.xxs) {
            HStack(spacing: VybeSpacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(VybeTypography.bodyMedium)
                        .foregroundStyle(isFocused ? VybeColors.accent : VybeColors.muted)
                        .frame(width: 20)
                }

                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(VybeTypography.bodyMedium)
                .foregroundStyle(VybeColors.foreground)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .focused($isFocused)
                .tint(VybeColors.accent)
            }
            .padding(.horizontal, VybeSpacing.md)
            .padding(.vertical, VybeSpacing.sm)
            .background {
                RoundedRectangle(cornerRadius: VybeSpacing.radiusMD, style: .continuous)
                    .fill(VybeColors.surface)
            }
            .overlay {
                RoundedRectangle(cornerRadius: VybeSpacing.radiusMD, style: .continuous)
                    .stroke(
                        borderColor,
                        lineWidth: isFocused ? 1.5 : 1
                    )
            }
            .animation(.easeInOut(duration: 0.2), value: isFocused)

            if let errorMessage {
                Text(errorMessage)
                    .font(VybeTypography.caption)
                    .foregroundStyle(VybeColors.danger)
                    .padding(.leading, VybeSpacing.xxs)
            }
        }
    }

    private var borderColor: Color {
        if errorMessage != nil {
            return VybeColors.danger
        }
        return isFocused ? VybeColors.accent.opacity(0.5) : VybeColors.border
    }
}

#Preview {
    VStack(spacing: 16) {
        VybeTextField(
            placeholder: "Search marketplace...",
            text: .constant(""),
            icon: "magnifyingglass"
        )
        VybeTextField(
            placeholder: "Phone number",
            text: .constant(""),
            icon: "phone",
            keyboardType: .phonePad
        )
        VybeTextField(
            placeholder: "Password",
            text: .constant(""),
            icon: "lock",
            isSecure: true,
            errorMessage: "Password must be at least 8 characters"
        )
    }
    .padding()
    .background(VybeColors.background)
}
