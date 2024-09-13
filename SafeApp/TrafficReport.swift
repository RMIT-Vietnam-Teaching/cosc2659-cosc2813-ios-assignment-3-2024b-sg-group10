import Foundation
import CoreLocation

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double

    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct TrafficReport: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var location: Coordinate
    var createdAt: Date
}
