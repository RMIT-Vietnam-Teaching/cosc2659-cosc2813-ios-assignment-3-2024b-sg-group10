import SwiftUI
import MapKit

struct MapView: View {
    @Binding var userLocation: CLLocationCoordinate2D? // Bind the user location from LocationManager
    @Binding var shouldRecenter: Bool // Binding to trigger re-centering
    
    var reports: [TrafficReport] // Existing reports
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542), // Default center
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var userAnnotation: [TrafficReport] = [] // Store user annotation separately

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: reports + userAnnotation) { report in
            MapAnnotation(coordinate: report.location.location) {
                VStack {
                    if report.title == "You are here" {
                        // Blue pin with surrounding translucent ring for user location
                        ZStack {
                            Circle()
                                .fill(Color.white) // Translucent ring
                                .frame(width: 23, height: 23)
                            
                            Circle()
                                .fill(Color.blue) // Blue pin
                                .frame(width: 20, height: 20)
                        }
                    } else {
                        // Red pin for traffic reports
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
        }
        .onAppear {
            if let userLocation = userLocation {
                // Center the map on the user's location on appear
                region = MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                
                // Update the user annotation
                userAnnotation = [TrafficReport(
                    id: UUID(),
                    title: "You are here",
                    description: "This is your current location",
                    location: Coordinate(latitude: userLocation.latitude, longitude: userLocation.longitude),
                    createdAt: Date()
                )]
            }
        }
        .onChange(of: shouldRecenter) { recenter in
            if recenter, let userLocation = userLocation {
                // Center the map on the user's location when re-centering is triggered
                region = MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                shouldRecenter = false // Reset the flag after re-centering
            }
        }
        .ignoresSafeArea()
    }
}


// Preview for MapView
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(
            userLocation: .constant(CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542)),
            shouldRecenter: .constant(false), // Provide a constant value for `shouldRecenter`
            reports: [
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
            ]
        )
        .previewLayout(.sizeThatFits)
    }
}
