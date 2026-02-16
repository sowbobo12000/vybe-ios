import Foundation

/// Utility formatters for price, distance, and time across the app.
enum Formatters {
    // MARK: - Price Formatting

    /// Format price in cents to a display string (e.g., 12500 -> "$125")
    static func formatPrice(_ cents: Int, currency: String = "USD") -> String {
        let dollars = Double(cents) / 100.0
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.maximumFractionDigits = dollars.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
        return formatter.string(from: NSNumber(value: dollars)) ?? "$\(Int(dollars))"
    }

    /// Format price with compact notation for large values (e.g., "$1.2K")
    static func formatPriceCompact(_ cents: Int) -> String {
        let dollars = Double(cents) / 100.0
        if dollars >= 1_000_000 {
            return String(format: "$%.1fM", dollars / 1_000_000)
        } else if dollars >= 1_000 {
            return String(format: "$%.1fK", dollars / 1_000)
        }
        return formatPrice(cents)
    }

    // MARK: - Distance Formatting

    /// Format distance in meters to a readable string
    static func formatDistance(_ meters: Double) -> String {
        if meters < 1000 {
            return "\(Int(meters))m away"
        }
        let miles = meters / 1609.34
        if miles < 10 {
            return String(format: "%.1f mi", miles)
        }
        return "\(Int(miles)) mi"
    }

    /// Format distance for display in listing cards
    static func formatDistanceShort(_ meters: Double) -> String {
        let miles = meters / 1609.34
        if miles < 0.1 {
            return "Nearby"
        } else if miles < 1 {
            return String(format: "%.1f mi", miles)
        } else if miles < 100 {
            return "\(Int(miles)) mi"
        }
        return "\(Int(miles))+ mi"
    }

    // MARK: - Count Formatting

    /// Format large numbers compactly (e.g., 1500 -> "1.5K")
    static func formatCount(_ count: Int) -> String {
        if count >= 1_000_000 {
            return String(format: "%.1fM", Double(count) / 1_000_000)
        } else if count >= 1_000 {
            return String(format: "%.1fK", Double(count) / 1_000)
        }
        return "\(count)"
    }

    // MARK: - Manner Temperature

    /// Format manner temperature as a display string
    static func formatMannerTemp(_ temp: Double) -> String {
        return String(format: "%.1f\u{00B0}", temp)
    }

    // MARK: - Phone Number

    /// Format phone number for display
    static func formatPhone(_ phone: String) -> String {
        let digits = phone.filter(\.isNumber)
        guard digits.count >= 10 else { return phone }
        let areaCode = digits.prefix(3)
        let middle = digits.dropFirst(3).prefix(3)
        let last = digits.dropFirst(6).prefix(4)
        return "(\(areaCode)) \(middle)-\(last)"
    }
}
