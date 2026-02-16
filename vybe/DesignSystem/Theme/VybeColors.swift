import SwiftUI

/// Central color palette for the vybe "Digital Aurora" design system.
/// All colors are defined as static properties for compile-time safety.
enum VybeColors {
    // MARK: - Dark Theme (Default)

    static let background = Color(hex: "#0A0A12")
    static let backgroundAlt = Color(hex: "#0E0F18")
    static let foreground = Color(hex: "#E8E6F0")
    static let surface = Color(hex: "#13141F")
    static let surfaceHover = Color(hex: "#1B1C2A")
    static let border = Color(hex: "#1F2036")
    static let borderGlow = Color(hex: "#2A2D4A")
    static let muted = Color(hex: "#8086B0")

    // MARK: - Accent Colors

    static let accent = Color(hex: "#B78AF7")        // Soft lavender
    static let accentPink = Color(hex: "#F0ABFC")     // Pastel orchid
    static let accentCyan = Color(hex: "#67E8F9")      // Pastel sky
    static let accentCoral = Color(hex: "#FDA4AF")     // Pastel rose

    // MARK: - Semantic Colors

    static let success = Color(hex: "#6EE7B7")
    static let warning = Color(hex: "#FCD34D")
    static let danger = Color(hex: "#FCA5A5")

    // MARK: - Light Theme

    static let lightBackground = Color(hex: "#FAF8F5")
    static let lightForeground = Color(hex: "#1A1A2E")
    static let lightSurface = Color.white
    static let lightAccent = Color(hex: "#9B6FE0")

    // MARK: - Gradients

    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "#C084FC"), Color(hex: "#A78BFA"), Color(hex: "#818CF8")],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let accentGradient = LinearGradient(
        colors: [accent, accentPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let auroraGradient = LinearGradient(
        colors: [
            Color(hex: "#B78AF7").opacity(0.3),
            Color(hex: "#67E8F9").opacity(0.2),
            Color(hex: "#F0ABFC").opacity(0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let warmGradient = LinearGradient(
        colors: [accentCoral, accentPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let coolGradient = LinearGradient(
        colors: [accentCyan, accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Manner Temperature Colors

    static func mannerTempColor(for temperature: Double) -> Color {
        switch temperature {
        case ..<30:
            return Color(hex: "#60A5FA")  // Cold blue
        case 30..<36:
            return accentCyan
        case 36..<37.5:
            return success
        case 37.5..<40:
            return warning
        case 40..<50:
            return accentCoral
        default:
            return danger
        }
    }
}
