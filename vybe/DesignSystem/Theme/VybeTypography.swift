import SwiftUI

/// Typography tokens for the vybe design system.
/// Uses system fonts that approximate the web app's Bricolage Grotesque (display)
/// and Outfit (body) typefaces.
enum VybeTypography {
    // MARK: - Display Fonts (Serif — approximates Bricolage Grotesque)

    static let displayLarge = Font.system(size: 40, weight: .bold, design: .serif)
    static let displayMedium = Font.system(size: 32, weight: .bold, design: .serif)
    static let displaySmall = Font.system(size: 24, weight: .semibold, design: .serif)

    // MARK: - Heading Fonts

    static let heading1 = Font.system(size: 28, weight: .bold, design: .default)
    static let heading2 = Font.system(size: 22, weight: .semibold, design: .default)
    static let heading3 = Font.system(size: 18, weight: .semibold, design: .default)
    static let heading4 = Font.system(size: 16, weight: .semibold, design: .default)

    // MARK: - Body Fonts (Sans-serif — approximates Outfit)

    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

    // MARK: - Label Fonts

    static let labelLarge = Font.system(size: 15, weight: .medium, design: .default)
    static let labelMedium = Font.system(size: 13, weight: .medium, design: .default)
    static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)

    // MARK: - Caption Fonts

    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let captionBold = Font.system(size: 12, weight: .semibold, design: .default)

    // MARK: - Monospace (for prices, codes)

    static let monoLarge = Font.system(size: 22, weight: .bold, design: .monospaced)
    static let monoMedium = Font.system(size: 17, weight: .semibold, design: .monospaced)
    static let monoSmall = Font.system(size: 13, weight: .medium, design: .monospaced)

    // MARK: - Price Display

    static let priceHero = Font.system(size: 32, weight: .bold, design: .rounded)
    static let priceLarge = Font.system(size: 20, weight: .bold, design: .rounded)
    static let priceMedium = Font.system(size: 16, weight: .semibold, design: .rounded)
    static let priceSmall = Font.system(size: 14, weight: .semibold, design: .rounded)
}
