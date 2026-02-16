import SwiftUI
import SwiftData

/// The main entry point for the vybe marketplace app.
@main
struct vybeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var router = AppRouter()
    @State private var authManager = AuthManager.shared
    @State private var themeManager = ThemeManager.shared
    @State private var locationManager = LocationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
                .environment(authManager)
                .environment(themeManager)
                .environment(locationManager)
                .preferredColorScheme(themeManager.colorScheme)
                .tint(VybeColors.accent)
                .onOpenURL { url in
                    let handler = DeepLinkHandler(router: router)
                    handler.handle(url: url)
                }
        }
        .modelContainer(for: [User.self, Listing.self])
    }
}
