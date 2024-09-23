/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Team 10
  ID: s3978826, s3978481, s388418, s3979367
  Created  date: 3/9/2024
  Last modified: 23/9/2024
  Acknowledgement: Acknowledge the resources that you use here.
*/
import SwiftUI
import Foundation

struct ReportIncidentScreen: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var selectedCautionType: String = "Traffic"
    @Environment(\.colorScheme) var colorScheme
    
    var latitude: String
    var longitude: String
    var token: String?

    let cautionTypes = [
        ("Traffic", "car.fill", "Heavy traffic ahead."),
        ("Police", "shield.fill", "Police checkpoint ahead."),
        ("Accident", "car.2.fill", "Car accident ahead."),
        ("Hazard", "exclamationmark.triangle.fill", "Road hazard detected."),
        ("Closure", "xmark", "Road closed ahead."),
        ("Blocked lane", "cone.fill", "Lane blocked ahead."),
        ("Map Issue", "exclamationmark.square.fill", "Map issue detected."),
        ("Bad weather", "cloud.rain.fill", "Bad weather conditions."),
        ("Fuel prices", "fuelpump.fill", "Fuel prices update."),
        ("Roadside help", "lifepreserver.fill", "Roadside assistance needed."),
        ("Map chat", "message.fill", "Chat related to map issues."),
        ("Place", "mappin.and.ellipse", "Point of interest.")
    ]

    var body: some View {
        VStack(spacing: 20) {
            headerView
            cautionSelectionView
            submitButton
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if let token = token {
                print("Token: \(token)")
            } else {
                print("No token available")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Text("Report Incident")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 5)
        }
    }
    
    private var cautionSelectionView: some View {  // Removed the parentheses here
            VStack {
                Text("Select Caution Type")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
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
                            title = caution.0  // Set the caution type as the title
                            description = caution.2  // Set the pre-defined description
                        }
                    }
                }
                .padding()
            }
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
        guard let lat = Double(latitude), let lon = Double(longitude) else {
            showAlert(title: "Error", message: "Invalid latitude or longitude")
            return
        }
        
        guard let reportUrl = URL(string: Constants.reportsEndpoint) else {
            showAlert(title: "Error", message: "Invalid URL")
            return
        }
        
        var reportRequest = URLRequest(url: reportUrl)
        reportRequest.httpMethod = "POST"
        reportRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            reportRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let reportData = [
            "title": title,
            "description": description,
            "location": [
                "latitude": lat,
                "longitude": lon
            ]
        ] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: reportData, options: [])
            reportRequest.httpBody = jsonData
            
            URLSession.shared.dataTask(with: reportRequest) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        showAlert(title: "Error", message: "Error sending report: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                        showAlert(title: "Error", message: "Unexpected response")
                        return
                    }
                    
                    sendNotification(title: reportData["title"] as? String ?? "New Incident Reported", message: reportData["description"] as? String ?? "A new incident has been reported.")
                }
            }.resume()
            
        } catch {
            showAlert(title: "Error", message: "Error encoding report data: \(error.localizedDescription)")
        }
    }
    
    private func sendNotification(title: String, message: String) {
        guard let notificationUrl = URL(string: Constants.notificationsEndpoint) else {
            showAlert(title: "Error", message: "Invalid URL for notifications")
            return
        }
        
        var notificationRequest = URLRequest(url: notificationUrl)
        notificationRequest.httpMethod = "POST"
        notificationRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            notificationRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let notificationData = [
            "title": title,
            "message": message
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: notificationData, options: [])
            notificationRequest.httpBody = jsonData
            
            URLSession.shared.dataTask(with: notificationRequest) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        showAlert(title: "Error", message: "Error sending notification: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                        showAlert(title: "Error", message: "Unexpected response for notification")
                        return
                    }
                    
                    showAlert(title: "Success", message: "Report submitted and notification sent successfully")
                }
            }.resume()
            
        } catch {
            showAlert(title: "Error", message: "Error encoding notification data: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

struct ReportIncidentScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReportIncidentScreen(latitude: "37.3347302", longitude: "-122.0089189", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU2ZDI0N2Q3ZDdkZmQwMzZkNzc1ZjYiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY2NDY5OTUsImV4cCI6MTcyNjczMzM5NX0.S-i79_AMlkLUiQmvY4hgmYvrmx72WnwlN6PR7_bbIPY")
    }
}
