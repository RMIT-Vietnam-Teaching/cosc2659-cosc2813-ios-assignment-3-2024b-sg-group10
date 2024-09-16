import SwiftUI
import MapKit

struct ReportIncidentScreen: View {
    @Binding var selectedCautionType: String
    @Environment(\.presentationMode) var presentationMode

    var onSubmit: (TrafficReport) -> Void
    var currentLocation: CLLocationCoordinate2D  // The current location is passed from HomeScreen
    
    let cautionTypes = [
        ("Traffic", "car.fill"), ("Police", "shield.fill"),
        ("Accident", "car.2.fill"), ("Hazard", "exclamationmark.triangle.fill"),
        ("Closure", "road.closed.fill"), ("Blocked lane", "cone.fill"),
        ("Map Issue", "exclamationmark.square.fill"), ("Bad weather", "cloud.rain.fill"),
        ("Fuel prices", "fuelpump.fill"), ("Roadside help", "lifepreserver.fill"),
        ("Map chat", "message.fill"), ("Place", "mappin.and.ellipse")
    ]
    
    @State private var latitude: String = ""
    @State private var longitude: String = ""

    var body: some View {
        VStack {
            HStack {
                Text("Report issue")
                    .font(.title)
                    .padding()
                
                Spacer()
                
                // Close Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 16)
            }
            
            // Caution Types
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                ForEach(cautionTypes, id: \.0) { caution in
                    VStack {
                        Image(systemName: caution.1)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .background(selectedCautionType == caution.0 ? Color.orange : Color.clear)
                            .cornerRadius(10)
                            .foregroundColor(.gray)
                        
                        Text(caution.0)
                            .font(.headline)
                            .foregroundColor(selectedCautionType == caution.0 ? .orange : .black)
                    }
                    .onTapGesture {
                        selectedCautionType = caution.0
                    }
                }
            }
            .padding()
            
            Spacer()

            // Report Button
            Button(action: {
                submitReport()  // Call the function to submit the report
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Report")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .onAppear {
            // Automatically set the current location values
            latitude = String(currentLocation.latitude)
            longitude = String(currentLocation.longitude)
        }
    }

    // Function to submit the report and pass the data back to HomeScreen
    private func submitReport() {
        guard let lat = Double(latitude), let lon = Double(longitude) else {
            return
        }

        let newReport = TrafficReport(
            id: UUID(),
            cautionType: selectedCautionType,
            location: Coordinate(latitude: lat, longitude: lon),
            createdAt: Date()
        )
        
        print("Submitting Report: \(newReport)")
        onSubmit(newReport)  // Pass the new report to the HomeScreen via the callback
    }
}

struct ReportIncidentScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReportIncidentScreen(
            selectedCautionType: .constant("Traffic"),
            onSubmit: { _ in },
            currentLocation: CLLocationCoordinate2D(latitude: 10.762622, longitude: 106.660172)
        )
    }
}
