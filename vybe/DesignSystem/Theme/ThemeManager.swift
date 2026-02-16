import SwiftUI

/// Manages the app's theme state (light/dark mode).
@Observable
@MainActor
final class ThemeManager {
    static let shared = ThemeManager()

    var colorScheme: ColorScheme = .dark
    var isDarkMode: Bool { colorScheme == .dark }

    private init() {}

    func toggle() {
        withAnimation(.easeInOut(duration: 0.3)) {
            colorScheme = isDarkMode ? .light : .dark
        }
    }

    // MARK: - Adaptive Colors

    var background: Color {
        isDarkMode ? VybeColors.background : VybeColors.lightBackground
    }

    var foreground: Color {
        isDarkMode ? VybeColors.foreground : VybeColors.lightForeground
    }

    var surface: Color {
        isDarkMode ? VybeColors.surface : VybeColors.lightSurface
    }

    var accent: Color {
        isDarkMode ? VybeColors.accent : VybeColors.lightAccent
    }

    var muted: Color {
        isDarkMode ? VybeColors.muted : VybeColors.muted.opacity(0.7)
    }

    var border: Color {
        isDarkMode ? VybeColors.border : Color.gray.opacity(0.2)
    }
}
