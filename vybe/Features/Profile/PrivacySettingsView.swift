import SwiftUI

/// Privacy settings screen.
struct PrivacySettingsView: View {
    @State private var showOnlineStatus = true
    @State private var showLocation = true
    @State private var showActivity = false

    var body: some View {
        List {
            Section {
                Toggle("Show Online Status", isOn: $showOnlineStatus)
                Toggle("Show Location", isOn: $showLocation)
                Toggle("Show Activity Feed", isOn: $showActivity)
            } header: {
                Text("Visibility")
            } footer: {
                Text("Control what other users can see about you.")
            }

            Section {
                Label("Terms of Service", systemImage: "doc.text")
                    .foregroundStyle(VybeColors.foreground)
                Label("Privacy Policy", systemImage: "hand.raised")
                    .foregroundStyle(VybeColors.foreground)
            } header: {
                Text("Legal")
            }
        }
        .tint(VybeColors.accent)
        .scrollContentBackground(.hidden)
        .background(VybeColors.background)
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        PrivacySettingsView()
    }
}
