import Foundation

struct Notification: Identifiable, Codable {
    var id: UUID
    var title: String
    var content: String
    var date: Date // Added date property
    
    var dateFormatted: String { // Formatted date string
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    static func getSampleNotifications() -> [Notification] {
        return [
            Notification(id: UUID(), title: "Roadblock", content: "Road blocked at XYZ street.", date: Date()),
            Notification(id: UUID(), title: "Accident", content: "Accident reported at ABC street.", date: Date().addingTimeInterval(-3600))
        ]
    }
}
