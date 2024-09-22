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
