import SwiftUI

/// Notification preferences screen.
struct NotificationSettingsView: View {
    @State private var pushEnabled = true
    @State private var chatNotifications = true
    @State private var offerNotifications = true
    @State private var priceDropNotifications = false
    @State private var communityNotifications = true

    var body: some View {
        List {
            Section {
                Toggle("Push Notifications", isOn: $pushEnabled)
            } header: {
                Text("General")
            } footer: {
                Text("Turn off to stop all notifications from vybe.")
            }

            Section {
                Toggle("Messages", isOn: $chatNotifications)
                Toggle("Offers & Bids", isOn: $offerNotifications)
                Toggle("Price Drops", isOn: $priceDropNotifications)
                Toggle("Community Updates", isOn: $communityNotifications)
            } header: {
                Text("Categories")
            }
        }
        .tint(VybeColors.accent)
        .scrollContentBackground(.hidden)
        .background(VybeColors.background)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
