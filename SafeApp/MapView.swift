import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Environment(\.colorScheme) var colorScheme
    
    var reports: [TrafficReport]
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: reports) { report in
            MapAnnotation(coordinate: report.location.location) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(colorScheme == .dark ? .yellow : .red)
                        .font(.title)
                    Text(report.title) 
                        .font(.caption)
                        .padding(5)
                        .background(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                }
            }
        }
        .ignoresSafeArea()
    }
}

// Preview for MapView
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(reports: [
            TrafficReport(
                id: UUID(),
                title: "Road blockage near Central Park",
                description: "A large tree has fallen and blocked the road.",
                location: Coordinate(latitude: 21.0280, longitude: 105.8540),
                createdAt: Date()
            ),
            TrafficReport(
                id: UUID(),
                title: "Accident on 7th Avenue",
                description: "Minor accident reported on 7th Avenue.",
                location: Coordinate(latitude: 21.0310, longitude: 105.8500),
                createdAt: Date()
            )
        ])
        .previewLayout(.sizeThatFits)
    }
}
