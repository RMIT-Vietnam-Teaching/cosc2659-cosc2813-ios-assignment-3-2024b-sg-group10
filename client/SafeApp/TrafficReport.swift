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
import CoreLocation

struct TrafficReport: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let location: Coordinate
    let createdAt: String
    
    // Sử dụng ISO8601DateFormatter để xử lý định dạng ngày chuẩn
    var createdDate: Date? {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return isoDateFormatter.date(from: createdAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case location
        case createdAt
    }
    
    struct Coordinate: Codable {
        let latitude: Double
        let longitude: Double

        var location: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
