import Foundation

extension Date {
    /// Returns a human-readable "time ago" string (e.g., "3 hours ago", "2 days ago")
    var timeAgo: String {
        let now = Date()
        let interval = now.timeIntervalSince(self)

        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else if interval < 604800 {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        } else if interval < 2592000 {
            let weeks = Int(interval / 604800)
            return "\(weeks)w ago"
        } else if interval < 31536000 {
            let months = Int(interval / 2592000)
            return "\(months)mo ago"
        } else {
            let years = Int(interval / 31536000)
            return "\(years)y ago"
        }
    }

    /// Returns a formatted date string for chat messages
    var chatTimestamp: String {
        let calendar = Calendar.current
        let formatter = DateFormatter()

        if calendar.isDateInToday(self) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: self)
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: self)
        } else {
            formatter.dateFormat = "MMM d"
            return formatter.string(from: self)
        }
    }

    /// Returns a formatted date string for listing detail
    var listingDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }

    /// Create a date relative to now by subtracting time components
    static func relative(days: Int = 0, hours: Int = 0, minutes: Int = 0) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = -days
        components.hour = -hours
        components.minute = -minutes
        return calendar.date(byAdding: components, to: Date()) ?? Date()
    }
}
