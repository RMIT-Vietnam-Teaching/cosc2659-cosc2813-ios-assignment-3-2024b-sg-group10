import SwiftUI

struct ReportIncidentScreen: View {
    @Binding var selectedCautionType: String
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    let cautionTypes = [
        ("Traffic", "car.fill"), ("Police", "shield.fill"),
        ("Accident", "car.2.fill"), ("Hazard", "exclamationmark.triangle.fill"),
        ("Closure", "xmark"), ("Blocked lane", "cone.fill"),
        ("Map Issue", "exclamationmark.square.fill"), ("Bad weather", "cloud.rain.fill"),
        ("Fuel prices", "fuelpump.fill"), ("Roadside help", "lifepreserver.fill"),
        ("Map chat", "message.fill"), ("Place", "mappin.and.ellipse")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Report issue")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
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
                .padding(.trailing)
            }
            .padding(.horizontal)
            
            // Caution Types
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 30) {
                ForEach(cautionTypes, id: \.0) { caution in
                    VStack {
                        Image(systemName: caution.1)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .background(selectedCautionType == caution.0 ? Color.orange : Color.clear)
                            .cornerRadius(10)
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                        Text(caution.0)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedCautionType == caution.0 ? .orange : (colorScheme == .dark ? .white : .black))
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
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

struct ReportIncident_Previews: PreviewProvider {
    static var previews: some View {
        ReportIncidentScreen(selectedCautionType: .constant("Traffic"))
    }
}
