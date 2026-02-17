import SwiftUI

/// App settings screen with appearance, notifications, privacy, and account actions.
struct SettingsView: View {
    @Environment(AppRouter.self) private var router
    @Environment(AuthManager.self) private var authManager
    @Environment(ThemeManager.self) private var themeManager

    @State private var showLogoutConfirm = false

    var body: some View {
        List {
            // MARK: - Appearance
            Section {
                HStack {
                    Label("Dark Mode", systemImage: "moon.fill")
                        .foregroundStyle(VybeColors.foreground)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { themeManager.isDarkMode },
                        set: { _ in themeManager.toggle() }
                    ))
                    .tint(VybeColors.accent)
                }
            } header: {
                Text("Appearance")
            }

            // MARK: - Notifications
            Section {
                Button {
                    router.navigate(to: .notificationSettings)
                } label: {
                    Label("Push Notifications", systemImage: "bell.badge")
                        .foregroundStyle(VybeColors.foreground)
                }
            } header: {
                Text("Notifications")
            }

            // MARK: - Privacy
            Section {
                Button {
                    router.navigate(to: .privacySettings)
                } label: {
                    Label("Privacy", systemImage: "lock.shield")
                        .foregroundStyle(VybeColors.foreground)
                }

                Label("Blocked Users", systemImage: "person.slash")
                    .foregroundStyle(VybeColors.foreground)
            } header: {
                Text("Privacy & Safety")
            }

            // MARK: - About
            Section {
                Button {
                    router.navigate(to: .about)
                } label: {
                    Label("About vybe", systemImage: "info.circle")
                        .foregroundStyle(VybeColors.foreground)
                }

                HStack {
                    Label("Version", systemImage: "gear")
                        .foregroundStyle(VybeColors.foreground)
                    Spacer()
                    Text("1.0.0")
                        .font(VybeTypography.bodySmall)
                        .foregroundStyle(VybeColors.muted)
                }
            } header: {
                Text("About")
            }

            // MARK: - Account
            Section {
                Button(role: .destructive) {
                    showLogoutConfirm = true
                } label: {
                    Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(VybeColors.danger)
                }

                Button(role: .destructive) {
                    // placeholder
                } label: {
                    Label("Delete Account", systemImage: "trash")
                        .foregroundStyle(VybeColors.danger.opacity(0.7))
                }
            } header: {
                Text("Account")
            }
        }
        .scrollContentBackground(.hidden)
        .background(VybeColors.background)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Log Out", isPresented: $showLogoutConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                authManager.logout()
                router.popToRoot()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(AppRouter())
    .environment(AuthManager.shared)
    .environment(ThemeManager.shared)
}
