import Foundation

// Model for notifications
struct Notification: Identifiable {
    let id: String
    let title: String
    let message: String
    let date: Date
    
    init(id: String, title: String, message: String, date: String) {
        self.id = id
        self.title = title
        self.message = message
        self.date = DateFormatter.iso8601.date(from: date) ?? Date()
    }
    
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Model for notification response from API
struct NotificationResponse: Codable {
    let _id: String
    let title: String
    let message: String
    let date: String
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
}
