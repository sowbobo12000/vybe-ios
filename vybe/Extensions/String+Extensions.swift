import Foundation

extension String {
    /// Masks a phone number for display (e.g., "***-****-5678")
    var maskedPhone: String {
        guard count >= 4 else { return self }
        let lastFour = suffix(4)
        return "***-****-\(lastFour)"
    }

    /// Check if string is a valid email format
    var isValidEmail: Bool {
        let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return self.wholeMatch(of: emailRegex) != nil
    }

    /// Check if string is a valid phone number (basic check)
    var isValidPhone: Bool {
        let digits = self.filter(\.isNumber)
        return digits.count >= 10 && digits.count <= 15
    }

    /// Returns initials from a name string (e.g., "John Doe" -> "JD")
    var initials: String {
        let components = self.split(separator: " ")
        let mapped = components.compactMap(\.first)
        return String(mapped.prefix(2)).uppercased()
    }

    /// Truncate string to a maximum length with ellipsis
    func truncated(to maxLength: Int) -> String {
        if self.count <= maxLength {
            return self
        }
        return String(self.prefix(maxLength)) + "..."
    }

    /// Format as a currency display string (assuming cents input)
    var asCurrencyFromCents: String {
        guard let value = Double(self) else { return "$0" }
        return Formatters.formatPrice(Int(value))
    }
}
