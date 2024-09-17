import SwiftUI

struct ReportIncidentScreen: View {
    @Binding var selectedCautionType: String
    @Environment(\.presentationMode) var presentationMode

    let cautionTypes = [
        ("Traffic", "car.fill"), ("Police", "shield.fill"),
        ("Accident", "car.2.fill"), ("Hazard", "exclamationmark.triangle.fill"),
        ("Closure", "road.closed.fill"), ("Blocked lane", "cone.fill"),
        ("Map Issue", "exclamationmark.square.fill"), ("Bad weather", "cloud.rain.fill"),
        ("Fuel prices", "fuelpump.fill"), ("Roadside help", "lifepreserver.fill"),
        ("Map chat", "message.fill"), ("Place", "mappin.and.ellipse")
    ]
    
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
    }
}

struct ReportIncident_Previews: PreviewProvider {
    static var previews: some View {
        ReportIncidentScreen(selectedCautionType: .constant("Traffic"))
    }
}
