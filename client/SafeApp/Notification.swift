/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Team 10
  ID: s3978826, s3978481, s388418, s3979367
  Created  date: 3/9/2024
  Last modified: 23/9/2024
  Acknowledgement: Acknowledge the resources that you use here.
*/
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
