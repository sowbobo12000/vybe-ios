import SwiftUI

/// Edit profile form for updating display name, username, bio, location, and avatar.
struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager

    @State private var displayName: String = ""
    @State private var username: String = ""
    @State private var bio: String = ""
    @State private var location: String = ""
    @State private var isSaving = false

    var body: some View {
        List {
            // Avatar section
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: VybeSpacing.sm) {
                        VybeAvatar(
                            name: displayName.isEmpty ? "User" : displayName,
                            imageURL: authManager.currentUser?.avatarURL,
                            size: .large
                        )

                        Button("Change Photo") {
                            // Photo picker placeholder
                        }
                        .font(VybeTypography.labelMedium)
                        .foregroundStyle(VybeColors.accent)
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }

            // Info section
            Section {
                VStack(alignment: .leading, spacing: VybeSpacing.xxs) {
                    Text("Display Name")
                        .font(VybeTypography.labelSmall)
                        .foregroundStyle(VybeColors.muted)
                    TextField("Display Name", text: $displayName)
                        .font(VybeTypography.bodyMedium)
                        .foregroundStyle(VybeColors.foreground)
                }

                VStack(alignment: .leading, spacing: VybeSpacing.xxs) {
                    Text("Username")
                        .font(VybeTypography.labelSmall)
                        .foregroundStyle(VybeColors.muted)
                    TextField("Username", text: $username)
                        .font(VybeTypography.bodyMedium)
                        .foregroundStyle(VybeColors.foreground)
                        .textInputAutocapitalization(.never)
                }

                VStack(alignment: .leading, spacing: VybeSpacing.xxs) {
                    Text("Bio")
                        .font(VybeTypography.labelSmall)
                        .foregroundStyle(VybeColors.muted)
                    TextField("Tell us about yourself...", text: $bio, axis: .vertical)
                        .font(VybeTypography.bodyMedium)
                        .foregroundStyle(VybeColors.foreground)
                        .lineLimit(3...6)
                }

                VStack(alignment: .leading, spacing: VybeSpacing.xxs) {
                    Text("Location")
                        .font(VybeTypography.labelSmall)
                        .foregroundStyle(VybeColors.muted)
                    TextField("e.g., Los Angeles, CA", text: $location)
                        .font(VybeTypography.bodyMedium)
                        .foregroundStyle(VybeColors.foreground)
                }
            } header: {
                Text("Profile Info")
            }
        }
        .scrollContentBackground(.hidden)
        .background(VybeColors.background)
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    saveProfile()
                } label: {
                    if isSaving {
                        ProgressView()
                            .tint(VybeColors.accent)
                    } else {
                        Text("Save")
                            .font(VybeTypography.labelMedium)
                            .foregroundStyle(VybeColors.accent)
                    }
                }
                .disabled(isSaving)
            }
        }
        .onAppear {
            if let user = authManager.currentUser {
                displayName = user.displayName
                username = user.username
                location = user.location ?? ""
            }
        }
    }

    private func saveProfile() {
        isSaving = true
        // Simulate save
        Task {
            try? await Task.sleep(for: .seconds(0.8))
            isSaving = false
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
    .environment(AuthManager.shared)
}
