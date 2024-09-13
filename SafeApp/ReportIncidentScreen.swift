import SwiftUI

struct ReportIncidentScreen: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    var body: some View {
        VStack(spacing: 25) {
            headerView
            
            inputField(title: "Title", text: $title, iconName: "pencil")
            inputField(title: "Description", text: $description, iconName: "text.justify")
            inputField(title: "Latitude", text: $latitude, iconName: "location", isDecimal: true)
            inputField(title: "Longitude", text: $longitude, iconName: "location", isDecimal: true)
            
            submitButton
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
    
    private var headerView: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
            
            Text("Report Incident")
                .font(.system(size: 32, weight: .bold))
                .padding(.top, 5)
        }
    }
    
    private func inputField(title: String, text: Binding<String>, iconName: String, isDecimal: Bool = false) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            TextField(title, text: text)
                .keyboardType(isDecimal ? .decimalPad : .default)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
    
    private var submitButton: some View {
        Button(action: submitReport) {
            HStack {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                Text("Submit Report")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
        }
        .padding(.top, 20)
    }
    
    private func submitReport() {
        guard let lat = Double(latitude), let lon = Double(longitude) else { return }
        let newReport = TrafficReport(
            id: UUID(),
            title: title,
            description: description,
            location: Coordinate(latitude: lat, longitude: lon),
            createdAt: Date()
        )
        print("New Report: \(newReport)")
    }
}

struct ReportIncidentScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReportIncidentScreen()
    }
}
