import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542), // Default location (Hanoi, Vietnam)
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var reports: [TrafficReport]
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: reports) { report in
            MapAnnotation(coordinate: report.location.location) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                    Text(report.cautionType)  // Display caution type instead of title
                        .font(.caption)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                }
            }
        }
    }
}

// Preview for MapView
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(reports: [
            TrafficReport(
                id: UUID(),
                cautionType: "Road blockage",
                location: Coordinate(latitude: 21.0280, longitude: 105.8540),
                createdAt: Date()
            ),
            TrafficReport(
                id: UUID(),
                cautionType: "Accident",
                location: Coordinate(latitude: 21.0310, longitude: 105.8500),
                createdAt: Date()
            )
        ])
        .previewLayout(.sizeThatFits)
    }
}
