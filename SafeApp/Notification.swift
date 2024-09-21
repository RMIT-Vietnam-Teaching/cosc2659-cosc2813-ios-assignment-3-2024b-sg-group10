import Foundation

struct Notification: Identifiable, Codable {
    let id: String
    let title: String
    let message: String
    let date: Date
    
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case message
        case date
    }
}

struct NotificationResponse: Codable {
    let _id: String
    let title: String
    let message: String
    let date: String // Ngày tháng là String trong phản hồi từ API
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO8601 format
        return formatter
    }()
}
