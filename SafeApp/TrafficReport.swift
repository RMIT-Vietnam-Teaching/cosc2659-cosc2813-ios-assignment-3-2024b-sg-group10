import Foundation
import CoreLocation

struct TrafficReport: Identifiable, Decodable {
    let id: String
    let title: String
    let description: String
    let location: Coordinate
    let createdAt: String
    
    var createdDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: createdAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case location
        case createdAt
    }
    
    struct Coordinate: Decodable {
        let latitude: Double
        let longitude: Double

        var location: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
